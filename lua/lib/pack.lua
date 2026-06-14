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

function M.load(spec)
	local name = plugin_name(spec)
	if loaded[name] then
		return
	end
	if loading[name] then
		error("Circular plugin dependency: " .. name)
	end

	loading[name] = true
	for _, dependency in ipairs(as_list(spec.dependencies)) do
		M.load(dependency)
	end

	loaded[name] = true
	vim.cmd.packadd({ vim.fn.escape(name, " "), magic = { file = false } })

	local opts = opts_for(spec)
	if spec.config then
		spec.config(spec, opts)
	elseif spec.module and spec.opts ~= nil then
		require(spec.module).setup(opts)
	end
	loading[name] = nil
end

local function is_lazy(spec)
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

local function key_desc(key)
	return type(key) == "table" and key.desc or nil
end

local function key_rhs(key)
	return type(key) == "table" and (key[2] or key.rhs) or nil
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
		local rhs = key_rhs(key)

		for _, mode in ipairs(modes) do
			vim.keymap.set(mode, lhs, function()
				M.load(spec)
				if type(rhs) == "function" then
					return rhs()
				elseif type(rhs) == "string" then
					return vim.cmd(rhs)
				end

				replay_key(mode, lhs)
			end, {
				desc = key_desc(key),
				silent = true,
			})
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

	vim.pack.add(vim.tbl_map(pack_spec, all_specs), { load = false })

	for _, spec in ipairs(specs) do
		if is_lazy(spec) then
			setup_lazy(spec)
		else
			M.load(spec)
		end
	end
end

return M
