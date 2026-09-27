local M = {}

local state = {
	buf = nil,
	active = nil,
}

local function start_dir()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	if vim.bo[buf].buftype == "" and name ~= "" then
		return vim.fs.dirname(name)
	end

	return vim.fn.getcwd(0)
end

local function notify_error(message)
	vim.notify("Just: " .. message, vim.log.levels.ERROR)
end

local function decode_metadata(result)
	if result.code ~= 0 then
		local stderr = result.stderr or ""
		local message = vim.trim(stderr ~= "" and stderr or (result.stdout or ""))
		return nil, message ~= "" and message or "could not find a justfile"
	end

	local ok, metadata = pcall(vim.json.decode, result.stdout or "")
	if not ok then
		return nil, "could not read recipe metadata"
	end

	return metadata
end

local function fetch_metadata(cwd, callback)
	if vim.fn.executable("just") ~= 1 then
		notify_error("the `just` executable is not available")
		return
	end

	vim.system({ "just", "--dump", "--dump-format", "json" }, { cwd = cwd, text = true }, function(result)
		vim.schedule(function()
			local metadata, err = decode_metadata(result)
			if not metadata then
				notify_error(err)
				return
			end
			callback(metadata)
		end)
	end)
end

local function public_recipes(metadata)
	local recipes = {}
	for _, recipe in pairs(metadata.recipes or {}) do
		if not recipe.private then
			table.insert(recipes, recipe)
		end
	end

	table.sort(recipes, function(left, right)
		return (left.namepath or left.name) < (right.namepath or right.name)
	end)
	return recipes
end

local function ensure_output_buffer()
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		return state.buf
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "just://output")
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "just-output"
	vim.bo[buf].swapfile = false
	state.buf = buf
	return buf
end

local function output_window(buf)
	local wins = vim.fn.win_findbuf(buf)
	if #wins > 0 then
		return wins[1]
	end

	vim.cmd("botright 12split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].winfixheight = true
	return win
end

local function set_output(lines)
	local buf = ensure_output_buffer()
	output_window(buf)
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].modified = false
	return buf
end

local function append_output(lines)
	if #lines == 0 or not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
		return
	end

	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, lines)
	vim.bo[state.buf].modifiable = false
	vim.bo[state.buf].modified = false

	for _, win in ipairs(vim.fn.win_findbuf(state.buf)) do
		vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(state.buf), 0 })
	end
end

local function clean_line(line)
	return line:gsub("\27%[[%d;?]*[ -/]*[@-~]", "")
end

local function consume(run, stream, data)
	if state.active ~= run or not data or #data == 0 then
		return
	end

	data[1] = run.tails[stream] .. data[1]
	local complete = {}
	for index = 1, #data - 1 do
		local line = clean_line(data[index])
		table.insert(complete, line)
		table.insert(run.lines, line)
	end
	run.tails[stream] = data[#data]
	append_output(complete)
end

local function flush_tails(run)
	local lines = {}
	for _, stream in ipairs({ "stdout", "stderr" }) do
		if run.tails[stream] ~= "" then
			local line = clean_line(run.tails[stream])
			table.insert(lines, line)
			table.insert(run.lines, line)
			run.tails[stream] = ""
		end
	end
	append_output(lines)
end

local function is_json_record(line)
	local trimmed = vim.trim(line)
	if not vim.startswith(trimmed, "{") and not vim.startswith(trimmed, "[") then
		return false
	end

	return pcall(vim.json.decode, trimmed)
end

local function quickfix_items(lines, cwd)
	local parse_lines = { "Entering directory '" .. cwd .. "'" }
	vim.list_extend(
		parse_lines,
		vim.tbl_filter(function(line)
			return not is_json_record(line)
		end, lines)
	)
	table.insert(parse_lines, "Leaving directory '" .. cwd .. "'")

	local parsed = vim.fn.getqflist({
		lines = parse_lines,
		efm = "%DEntering directory '%f',%XLeaving directory '%f'," .. vim.o.errorformat,
	})

	return vim.tbl_filter(function(item)
		return item.valid == 1 and item.bufnr > 0 and item.lnum > 0
	end, parsed.items or {})
end

local function finish(run, code)
	if state.active ~= run then
		return
	end

	flush_tails(run)
	state.active = nil
	append_output({ "", ("[exited %d]"):format(code) })

	local items = quickfix_items(run.lines, run.cwd)
	if #items > 0 then
		require("lib.quickfix").set_items("just " .. run.recipe, items)
	elseif code == 0 then
		vim.notify("Just: " .. run.recipe .. " completed", vim.log.levels.INFO)
	else
		notify_error(run.recipe .. " failed with exit code " .. code)
	end
end

local function launch(recipe, args, cwd)
	local command = { "just", "--color", "never", recipe }
	vim.list_extend(command, args or {})
	set_output({ "$ " .. table.concat(command, " "), "" })

	local run = {
		recipe = recipe,
		cwd = cwd,
		lines = {},
		tails = { stdout = "", stderr = "" },
	}

	local job = vim.fn.jobstart(command, {
		cwd = cwd,
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = vim.schedule_wrap(function(_, data)
			consume(run, "stdout", data)
		end),
		on_stderr = vim.schedule_wrap(function(_, data)
			consume(run, "stderr", data)
		end),
		on_exit = vim.schedule_wrap(function(_, code)
			finish(run, code)
		end),
	})

	if job <= 0 then
		notify_error("could not start recipe " .. recipe)
		return
	end

	run.id = job
	state.active = run
end

local function start(recipe, args, cwd)
	if not state.active then
		launch(recipe, args, cwd)
		return
	end

	local active = state.active
	vim.ui.select({ "Stop and run " .. recipe, "Keep " .. active.recipe .. " running" }, {
		prompt = "A just recipe is already running",
	}, function(choice)
		if choice ~= "Stop and run " .. recipe or state.active ~= active then
			return
		end
		vim.fn.jobstop(active.id)
		launch(recipe, args, cwd)
	end)
end

local function recipe_cwd(metadata, fallback)
	return metadata.source and vim.fs.dirname(metadata.source) or fallback
end

function M.run(recipe, args)
	local cwd = start_dir()
	fetch_metadata(cwd, function(metadata)
		start(recipe, args or {}, recipe_cwd(metadata, cwd))
	end)
end

function M.pick()
	local cwd = start_dir()
	fetch_metadata(cwd, function(metadata)
		local recipes = public_recipes(metadata)
		if #recipes == 0 then
			vim.notify("Just: no public recipes found", vim.log.levels.INFO)
			return
		end

		vim.ui.select(recipes, {
			prompt = "Just recipes",
			format_item = function(recipe)
				local label = recipe.namepath or recipe.name
				if type(recipe.doc) == "string" and recipe.doc ~= "" then
					return label .. " — " .. recipe.doc
				end
				return label
			end,
		}, function(recipe)
			if not recipe then
				return
			end
			local name = recipe.namepath or recipe.name
			if #(recipe.parameters or {}) > 0 then
				vim.notify("Just: run parameterized recipes with :Just " .. name .. " <args>", vim.log.levels.INFO)
				return
			end
			start(name, {}, recipe_cwd(metadata, cwd))
		end)
	end)
end

local function complete(arg_lead, cmdline, cursor_pos)
	local before_cursor = cmdline:sub(1, cursor_pos)
	if before_cursor:match("^%s*Just%s+%S+%s+") then
		return {}
	end

	local result = vim.system({ "just", "--summary" }, { cwd = start_dir(), text = true }):wait()
	if result.code ~= 0 then
		return {}
	end

	return vim.tbl_filter(function(name)
		return vim.startswith(name, arg_lead)
	end, vim.split(vim.trim(result.stdout or ""), "%s+", { trimempty = true }))
end

function M.setup()
	vim.api.nvim_create_user_command("Just", function(args)
		if #args.fargs == 0 then
			M.pick()
			return
		end

		local recipe = table.remove(args.fargs, 1)
		M.run(recipe, args.fargs)
	end, {
		nargs = "*",
		complete = complete,
		desc = "Pick or run a just recipe",
	})

	vim.keymap.set("n", "<leader>j", M.pick, { desc = "Run just recipe" })
end

return M
