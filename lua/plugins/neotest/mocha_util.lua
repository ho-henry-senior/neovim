local lib = require("neotest.lib")

local M = {}

local function normalize_test_title(value)
	return value:gsub("\r", "\\r"):gsub("\n", "\\n"):gsub("\t", "\\t"):gsub("\\\\", "\\")
end

local function normalize_segment(value)
	value = normalize_test_title(value)
	local first = value:sub(1, 1)
	local last = value:sub(-1)
	if (first == "'" or first == '"' or first == "`") and first == last then
		return value:sub(2, -2)
	end
	return value
end

local function canonical_tree_key(id)
	local segments = vim.split(id, "::", { plain = true })
	for index = 2, #segments do
		segments[index] = normalize_segment(segments[index])
	end
	return table.concat(segments, " ")
end

function M.find_package_json_ancestor(startpath)
	if not startpath or startpath == "" then
		return nil
	end

	local stat = vim.uv.fs_stat(startpath)
	local search_path = stat and stat.type == "directory" and startpath or vim.fs.dirname(startpath)
	local package_json = vim.fs.find("package.json", {
		path = search_path,
		upward = true,
	})[1]

	return package_json and vim.fs.dirname(package_json) or nil
end

function M.get_mocha_command(path)
	local root_path = M.find_package_json_ancestor(path)
	if not root_path then
		return "mocha"
	end

	local mocha_binary = root_path .. "/node_modules/.bin/mocha"
	if vim.fn.executable(mocha_binary) == 1 then
		return mocha_binary
	end

	return "mocha"
end

function M.get_mocha_command_args(context)
	return {
		"--full-trace",
		"--reporter=json",
		"--reporter-options=output=" .. context.results_path,
		"--grep=" .. context.test_name_pattern,
		context.path,
	}
end

function M.escape_test_pattern(value)
	return (
		value
			:gsub("%(", "%\\(")
			:gsub("%)", "%\\)")
			:gsub("%]", "%\\]")
			:gsub("%[", "%\\[")
			:gsub("%*", "%\\*")
			:gsub("%+", "%\\+")
			:gsub("%-", "%\\-")
			:gsub("%?", "%\\?")
			:gsub("%$", "%\\$")
			:gsub("%^", "%\\^")
			:gsub("%/", "%\\/")
	)
end

function M.get_strategy_config(strategy, command, cwd)
	if strategy ~= "dap" then
		return nil
	end

	return {
		name = "Debug Mocha Tests",
		type = "pwa-node",
		request = "launch",
		args = { unpack(command, 2) },
		runtimeExecutable = command[1],
		console = "integratedTerminal",
		internalConsoleOptions = "neverOpen",
		cwd = cwd or "${workspaceFolder}",
	}
end

function M.get_env(env)
	return env
end

function M.get_cwd(_)
	return nil
end

function M.clean_ansi(value)
	return value
		:gsub("\x1b%[%d+;%d+;%d+;%d+;%d+m", "")
		:gsub("\x1b%[%d+;%d+;%d+;%d+m", "")
		:gsub("\x1b%[%d+;%d+;%d+m", "")
		:gsub("\x1b%[%d+;%d+m", "")
		:gsub("\x1b%[%d+m", "")
end

function M.find_error_position(file, err_str)
	local regexp = file:gsub("([^%w])", "%%%1") .. "%:(%d+)%:(%d+)"
	local _, _, err_line, err_column = string.find(err_str, regexp)
	return err_line, err_column
end

function M.parsed_json_to_results(data, tree, console_out)
	local tests = {}

	for _, test in pairs(data.tests) do
		local test_key = test.file .. " " .. test.fullTitle
		local normalized_test_key = normalize_test_title(test_key)
		local name = test.title
		local errors = {}
		local test_node

		for _, node in tree:iter() do
			local node_key = canonical_tree_key(node.id)
			if normalized_test_key == node_key then
				test_node = node
				break
			end
		end

		if not test_node then
			goto continue
		end

		local status
		if not vim.tbl_isempty(test.err) then
			status = "failed"
		elseif test.duration ~= nil then
			status = "passed"
		else
			status = "skipped"
		end

		local short = name .. ": " .. status
		if status == "failed" then
			local msg = M.clean_ansi(test.err.message)
			local error_line, error_column = M.find_error_position(test.file, test.err.stack)

			table.insert(errors, {
				line = error_line and error_line - 1 or test_node.range[1],
				column = error_column and error_column - 1 or test_node.range[2],
				message = msg,
			})

			short = short .. "\n" .. msg
		end

		tests[test_node.id] = {
			status = status,
			output = console_out,
			short = short,
			errors = errors,
		}

		::continue::
	end

	local function merge_status(existing, incoming)
		if existing == "failed" or incoming == "failed" then
			return "failed"
		end
		if existing == "passed" or incoming == "passed" then
			return "passed"
		end
		return incoming or existing or "skipped"
	end

	local aggregated = {}
	for _, node in tree:iter_nodes() do
		local result = tests[node:data().id]
		if result then
			for parent in node:iter_parents() do
				local parent_id = parent:data().id
				aggregated[parent_id] = merge_status(aggregated[parent_id], result.status)
			end
		end
	end

	for pos_id, status in pairs(aggregated) do
		if not tests[pos_id] then
			local node = tree:get_key(pos_id)
			local name = node and node:data().name or pos_id
			tests[pos_id] = {
				status = status,
				output = console_out,
				short = ("%s: %s"):format(name, status),
				errors = {},
			}
		end
	end

	return tests
end

function M.create_test_file_extensions_matcher(intermediate_extensions, end_extensions)
	return function(file_path)
		if not file_path then
			return false
		end

		for _, intermediate in ipairs(intermediate_extensions) do
			for _, extension in ipairs(end_extensions) do
				if string.match(file_path, intermediate .. "%." .. extension .. "$") then
					return true
				end
			end
		end

		return false
	end
end

function M.has_package_dependency(path, package_name)
	local full_path = path .. "/package.json"
	if not lib.files.exists(full_path) then
		return false
	end

	local ok, package_json_content = pcall(lib.files.read, full_path)
	if not ok then
		return false
	end

	local parsed_package_json = vim.json.decode(package_json_content)
	if not parsed_package_json then
		return false
	end

	for _, field in ipairs({ "dependencies", "devDependencies" }) do
		local dependencies = parsed_package_json[field] or {}
		for key, _ in pairs(dependencies) do
			if key == package_name then
				return true
			end
		end
	end

	return false
end

return M
