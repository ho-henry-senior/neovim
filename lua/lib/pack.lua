-- Thin layer over vim.pack for declarative plugin specs with lazy loading.
--
-- Each spec may include:
--   src, name, version   passed through to vim.pack
--   dependencies         nested specs loaded before the parent
--   init                 runs before load (for pre-load globals)
--   module, opts         shorthand for require(module).setup(opts)
--   config               full setup function, receives (spec, opts)
--   lazy                 if true, skip eager load (must combine with a trigger)
--   event, ft, cmd       load triggers: autocmd event, filetype, or user command
--   keys                 plugin-owned keymaps; act as load triggers if the plugin is lazy
--
-- A plugin is lazy if lazy=true or any of event/ft/cmd/keys are set. Lazy plugins
-- load on first use of their trigger. Non-lazy plugins load at startup.

local M = {}

local loaded = {}
local loading = {}

local function plugin_name(spec)
	if spec.name then
		return spec.name
	end

	local name = spec.src:gsub("%.git$", "")
	return name:match("[^/]+$") or name
end

local function as_list(value)
	if value == nil then
		return {}
	end

	if type(value) == "table" then
		return vim.islist(value) and value or { value }
	end

	return { value }
end

local function pack_spec(spec)
	return {
		src = spec.src,
		name = spec.name,
		version = spec.version,
	}
end

local function collect_specs(specs, collected)
	collected = collected or {}

	for _, spec in ipairs(specs) do
		collect_specs(as_list(spec.dependencies), collected)
		table.insert(collected, spec)
	end

	return collected
end

local function opts_for(spec)
	if type(spec.opts) == "function" then
		return spec.opts(spec)
	end

	return spec.opts or {}
end

local function run_init(specs)
	for _, spec in ipairs(specs) do
		if spec.init then
			spec.init(spec)
		end
	end
end

function M.load(spec)
	local name = plugin_name(spec)
	if loaded[name] then
		return
	end
	if loading[name] then
		error("Circular plugin dependency: " .. name)
	end

	loading[name] = true
	local ok, err = pcall(function()
		for _, dependency in ipairs(as_list(spec.dependencies)) do
			M.load(dependency)
		end

		vim.cmd.packadd({ vim.fn.escape(name, " "), magic = { file = false } })

		local opts = opts_for(spec)
		if spec.config then
			spec.config(spec, opts)
		elseif spec.module and spec.opts ~= nil then
			require(spec.module).setup(opts)
		end
	end)
	loading[name] = nil
	if ok then
		loaded[name] = true
	else
		error(err, 0)
	end
end

local function is_lazy(spec)
	return spec.lazy == true or spec.event ~= nil or spec.ft ~= nil or spec.cmd ~= nil or spec.keys ~= nil
end

local function has_handlers(spec)
	return spec.event ~= nil or spec.ft ~= nil or spec.cmd ~= nil or spec.keys ~= nil
end

local function load_on_event(spec)
	for _, event in ipairs(as_list(spec.event)) do
		vim.api.nvim_create_autocmd(event, {
			pattern = spec.pattern or "*",
			once = true,
			callback = function()
				M.load(spec)
			end,
		})
	end
end

local function load_on_filetype(spec)
	for _, ft in ipairs(as_list(spec.ft)) do
		vim.api.nvim_create_autocmd("FileType", {
			pattern = ft,
			once = true,
			callback = function()
				M.load(spec)
			end,
		})
	end
end

local function command_range(args)
	if args.range == 0 then
		return nil
	end

	if args.line1 == args.line2 then
		return tostring(args.line1)
	end

	return args.line1 .. "," .. args.line2
end

local function run_command(name, args)
	local command = {}
	if args.mods and args.mods ~= "" then
		table.insert(command, args.mods)
	end
	local range = command_range(args)
	if range then
		table.insert(command, range)
	end
	table.insert(command, name .. (args.bang and "!" or ""))
	if args.args and args.args ~= "" then
		table.insert(command, args.args)
	end

	vim.cmd(table.concat(
		vim.tbl_filter(function(part)
			return part ~= nil and part ~= ""
		end, command),
		" "
	))
end

local function load_on_command(spec)
	for _, name in ipairs(as_list(spec.cmd)) do
		vim.api.nvim_create_user_command(name, function(args)
			pcall(vim.api.nvim_del_user_command, name)
			M.load(spec)
			run_command(name, args)
		end, {
			bang = true,
			bar = true,
			complete = "file",
			nargs = "*",
			range = true,
		})
	end
end

local function key_lhs(key)
	return type(key) == "table" and (key[1] or key.lhs) or key
end

local function key_modes(key)
	return type(key) == "table" and (key.mode or key.modes or "n") or "n"
end

local function key_callback(key)
	return type(key) == "table" and (key.callback or key[2] or key.rhs) or nil
end

local function key_command(key)
	return type(key) == "table" and key.cmd or nil
end

local function key_options(key)
	if type(key) ~= "table" then
		return { silent = true }
	end

	return {
		desc = key.desc,
		expr = key.expr,
		nowait = key.nowait,
		remap = key.remap,
		silent = key.silent ~= false,
	}
end

local function run_key_command(command)
	if type(command) == "function" then
		return command()
	end

	return vim.cmd(command)
end

local function run_key_callback(callback)
	if type(callback) == "function" then
		return callback()
	end

	return vim.cmd(callback)
end

local function delete_placeholder_command(command)
	if type(command) ~= "string" then
		return
	end

	local name = command:match("^%s*(%S+)")
	if name then
		pcall(vim.api.nvim_del_user_command, name)
	end
end

local function replay_key(mode, lhs)
	pcall(vim.keymap.del, mode, lhs)
	local keys = vim.api.nvim_replace_termcodes(lhs, true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end

local function load_on_keys(spec)
	for _, key in ipairs(as_list(spec.keys)) do
		local lhs = key_lhs(key)
		local modes = as_list(key_modes(key))
		local callback = key_callback(key)
		local command = key_command(key)
		local opts = key_options(key)

		for _, mode in ipairs(modes) do
			vim.keymap.set(mode, lhs, function()
				if not loaded[plugin_name(spec)] then
					delete_placeholder_command(command)
				end
				M.load(spec)
				if callback then
					return run_key_callback(callback)
				elseif command then
					return run_key_command(command)
				end

				replay_key(mode, lhs)
			end, opts)
		end
	end
end

local function setup_lazy(spec)
	load_on_event(spec)
	load_on_filetype(spec)
	load_on_command(spec)
	load_on_keys(spec)
end

function M.setup(specs)
	local all_specs = collect_specs(specs)

	run_init(all_specs)
	vim.pack.add(vim.tbl_map(pack_spec, all_specs), { load = false })

	for _, spec in ipairs(specs) do
		if has_handlers(spec) then
			setup_lazy(spec)
		end

		if not is_lazy(spec) then
			M.load(spec)
		end
	end
end

return M
