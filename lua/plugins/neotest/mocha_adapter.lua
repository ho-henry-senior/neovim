local async = require("neotest.async")
local lib = require("neotest.lib")
local logger = require("neotest.logging")
local util = require("plugins.neotest.mocha_util")

local get_mocha_command = util.get_mocha_command
local get_mocha_command_args = util.get_mocha_command_args
local get_env = util.get_env
local get_cwd = util.get_cwd

local Adapter = { name = "neotest-mocha" }

Adapter.root = lib.files.match_root_pattern("package.json")

local default_is_test_file = util.create_test_file_extensions_matcher(
	{ "spec", "test" },
	{ "js", "mjs", "cjs", "jsx", "coffee", "ts", "tsx" }
)

local is_test_file = default_is_test_file

function Adapter.is_test_file(file_path)
	local root_path = util.find_package_json_ancestor(file_path)
	if not root_path then
		return false
	end

	return is_test_file(file_path) and util.has_package_dependency(root_path, "mocha")
end

function Adapter.filter_dir(name)
	return name ~= "node_modules"
end

local function get_string_from_template_literal(value)
	local matched = string.match(value, "^`(.*)`$")
	if not matched then
		return value
	end

	return (
		matched
			:gsub("%${.*}", ".*")
			:gsub("%%s", "\\w*")
			:gsub("%%i", "\\d*")
			:gsub("%%d", ".*")
			:gsub("%%f", ".*")
			:gsub("%%j", ".*")
			:gsub("%%o", ".*")
			:gsub("%%#", "\\d*")
	)
end

local function is_template_literal(value)
	return string.sub(value, 1, 1) == "`"
end

local function is_quoted_string(value)
	local first = value:sub(1, 1)
	local last = value:sub(-1)
	return (first == "'" or first == '"') and first == last
end

local function normalize_string_literal(value)
	if is_template_literal(value) then
		return get_string_from_template_literal(value)
	end

	if is_quoted_string(value) then
		return value:sub(2, -2)
	end

	return value
end

local function replace_id_suffix(id, new_name)
	local prefix = id:match("^(.*)::[^:]+$")
	if prefix then
		return prefix .. "::" .. new_name
	end

	return id
end

local function normalize_id_segments(id)
	local segments = vim.split(id, "::", { plain = true })
	for index, segment in ipairs(segments) do
		if index > 1 then
			segments[index] = normalize_string_literal(segment)
		end
	end
	return table.concat(segments, "::")
end

function Adapter.discover_positions(file_path)
	local query = [[
    ; -- Namespaces --
    ((call_expression
      function: (identifier) @func_name (#any-of? @func_name "describe" "context")
      arguments: (arguments [(string) @namespace.name (template_string) @namespace.name] (_))
    )) @namespace.definition
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "describe" "context")
      )
      arguments: (arguments [(string) @namespace.name (template_string) @namespace.name] (_))
    )) @namespace.definition

    ; -- Tests --
    ((call_expression
      function: (identifier) @func_name (#any-of? @func_name "it" "specify")
      arguments: (arguments [(template_string) @test.name (string) @test.name]  [(arrow_function) (function_expression)])
    )) @test.definition
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "it" "specify")
      )
      arguments: (arguments [(template_string) @test.name (string) @test.name]  [(arrow_function) (function_expression)])
    )) @test.definition
  ]]

	local parsed_tree = lib.treesitter.parse_positions(file_path, query, { nested_tests = true })

	for _, node in parsed_tree:iter_nodes() do
		if #node:children() > 0 then
			for _, pos in node:iter_nodes() do
				local data = pos:data()
				if data.type == "test" or data.type == "namespace" then
					local original_id = data.id
					local normalized_name = normalize_string_literal(data.name)
					local normalized_id = normalize_id_segments(replace_id_suffix(original_id, normalized_name))
					if normalized_name ~= data.name or normalized_id ~= original_id then
						local position_node = parsed_tree:get_key(original_id)
						if not position_node then
							return
						end

						data.name = normalized_name
						data.id = normalized_id

						local parent = position_node:parent()
						if parent then
							for i, child in pairs(parent._children) do
								if original_id == child:data().id then
									parent._children[i]:data().id = data.id
								end
							end
						end
						position_node._parent = parent
					end
				end
			end
		end
	end

	return parsed_tree
end

function Adapter.build_spec(args)
	local results_path = async.fn.tempname() .. ".json"
	local tree = args.tree
	if not tree then
		return {}
	end

	local pos = tree:data()
	if pos.type == "dir" then
		return nil
	end

	local test_name_pattern = ".*"
	local test_name = ""

	if pos.type == "test" or pos.type == "namespace" then
		test_name = string.sub(pos.id, string.find(pos.id, "::") + 2)
		test_name, _ = string.gsub(test_name, "::", " ")
		test_name_pattern = "^" .. util.escape_test_pattern(test_name) .. (pos.type == "test" and "$" or "")
	end

	local binary = get_mocha_command(pos.path)
	local command = vim.split(binary, "%s+")
	local command_args = get_mocha_command_args({
		results_path = results_path,
		test_name = test_name,
		test_name_pattern = test_name_pattern,
		path = pos.path,
	})

	if vim.islist(command_args) then
		vim.list_extend(command, command_args)
	end

	local cwd = get_cwd(pos.path)

	return {
		command = command,
		cwd = cwd,
		context = {
			results_path = results_path,
			file = pos.path,
		},
		strategy = util.get_strategy_config(args.strategy, command, cwd),
		env = get_env(args[2] and args[2].env or {}),
	}
end

function Adapter.results(spec, result, tree)
	local output_file = spec.context.results_path
	local success, data = pcall(lib.files.read, output_file)
	if not success then
		logger.error("No test output file found ", output_file)
		return {}
	end

	local ok, parsed = pcall(vim.json.decode, data, { luanil = { object = true } })
	if not ok then
		logger.error("Failed to parse test output json ", output_file)
		return {}
	end

	return util.parsed_json_to_results(parsed, tree, result.output)
end

local function is_callable(object)
	return type(object) == "function" or (type(object) == "table" and object.__call)
end

setmetatable(Adapter, {
	__call = function(_, opts)
		is_test_file = opts.is_test_file or is_test_file

		if is_callable(opts.command) then
			get_mocha_command = opts.command
		elseif opts.command then
			get_mocha_command = function()
				return opts.command
			end
		end

		if is_callable(opts.command_args) then
			get_mocha_command_args = opts.command_args
		end

		if is_callable(opts.env) then
			get_env = opts.env
		elseif opts.env then
			get_env = function(env)
				return vim.tbl_extend("force", opts.env, env)
			end
		end

		if is_callable(opts.cwd) then
			get_cwd = opts.cwd
		elseif opts.cwd then
			get_cwd = function()
				return opts.cwd
			end
		end

		return Adapter
	end,
})

return Adapter
