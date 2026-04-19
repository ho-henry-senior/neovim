vim.pack.add({
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/nvim-neotest/nvim-nio",
})

local neotest = require("neotest")
local nio = require("nio")
local jest_util = require("neotest-jest.jest-util")
local jest_path_util = require("neotest-jest.util")

local jest_config_names = {
	"jest.config.js",
	"jest.config.cjs",
	"jest.config.mjs",
	"jest.config.ts",
}

local current_test_path = nil
local current_mocha_path = nil

local function find_jest_config(path)
	if not path or path == "" then
		return nil
	end

	return vim.fs.find(jest_config_names, {
		path = vim.fs.dirname(path),
		upward = true,
	})[1]
end

local function get_jest_command(file_path)
	-- Load dotenv before Jest starts so projects that read env vars at import
	-- time behave the same under neotest as they do under `node -r dotenv/config`.
	return ("node -r dotenv/config %s"):format(jest_util.getJestCommand(file_path))
end

local function parse_dotenv(path)
	local env = {}
	local file = io.open(path, "r")
	if not file then
		return env
	end

	for line in file:lines() do
		local trimmed = vim.trim(line)
		if trimmed ~= "" and not trimmed:match("^#") then
			local key, value = trimmed:match("^([%w_]+)%s*=%s*(.*)$")
			if key then
				value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
				env[key] = value
			end
		end
	end

	file:close()

	return env
end

local function find_package_root(path)
	if not path or path == "" then
		return nil
	end

	local stat = vim.uv.fs_stat(path)
	local search_path = stat and stat.type == "directory" and path or vim.fs.dirname(path)

	local package_json = vim.fs.find("package.json", {
		path = search_path,
		upward = true,
	})[1]

	return package_json and vim.fs.dirname(package_json) or nil
end

local function load_env_files(file_path, file_names)
	local env = vim.fn.environ()
	if not file_path or file_path == "" then
		return env
	end

	local env_files = vim.fs.find(file_names, {
		path = vim.fs.dirname(file_path),
		upward = true,
	})

	for i = #env_files, 1, -1 do
		env = vim.tbl_extend("force", env, parse_dotenv(env_files[i]))
	end

	return env
end

local function load_jest_env(file_path)
	return load_env_files(file_path, { ".env.test.local", ".env.test", ".env.local", ".env" })
end

local function load_mocha_env(file_path)
	local env = load_env_files(file_path, { ".env.dev", ".env.local", ".env" })
	local package_root = find_package_root(file_path)
	if not package_root then
		return env
	end

	local repo_root = vim.fs.dirname(package_root)
	for _, env_file in ipairs({ ".env.dev", ".env.local", ".env" }) do
		local path = repo_root .. "/" .. env_file
		if vim.uv.fs_stat(path) then
			env = vim.tbl_extend("force", env, parse_dotenv(path))
		end
	end

	return env
end

local function package_json_has_jest(path)
	local file = io.open(path, "r")
	if not file then
		return false
	end

	local content = file:read("*a")
	file:close()

	local ok, parsed = pcall(vim.json.decode, content)
	if not ok or type(parsed) ~= "table" then
		return false
	end

	for _, field in ipairs({ "dependencies", "devDependencies" }) do
		local deps = parsed[field]
		if type(deps) == "table" and deps.jest then
			return true
		end
	end

	local scripts = parsed.scripts
	if type(scripts) == "table" then
		for _, command in pairs(scripts) do
			if type(command) == "string" and command:match("%f[%w]jest%f[%W]") then
				return true
			end
		end
	end

	return false
end

local function package_json_has_dependency(path, package_name)
	local file = io.open(path, "r")
	if not file then
		return false
	end

	local content = file:read("*a")
	file:close()

	local ok, parsed = pcall(vim.json.decode, content)
	if not ok or type(parsed) ~= "table" then
		return false
	end

	for _, field in ipairs({ "dependencies", "devDependencies" }) do
		local deps = parsed[field]
		if type(deps) == "table" and deps[package_name] then
			return true
		end
	end

	local scripts = parsed.scripts
	if type(scripts) == "table" then
		for _, command in pairs(scripts) do
			if type(command) == "string" and command:match("%f[%w]" .. package_name .. "%f[%W]") then
				return true
			end
		end
	end

	return false
end

local function find_project_binary(path, binary_name)
	local root = find_package_root(path)
	if not root then
		return nil
	end

	local binary = root .. "/node_modules/.bin/" .. binary_name
	return vim.fn.executable(binary) == 1 and binary or nil
end

local function is_jest_test_file(file_path)
	if not file_path or file_path == "" then
		return false
	end

	if file_path:match("/dist/") or file_path:match("/build/") or file_path:match("/coverage/") then
		return false
	end

	if not jest_path_util.defaultTestFileMatcher(file_path) then
		return false
	end

	if find_jest_config(file_path) then
		return true
	end

	local package_json = vim.fs.find("package.json", {
		path = vim.fs.dirname(file_path),
		upward = true,
	})[1]

	return package_json and package_json_has_jest(package_json) or false
end

local function is_mocha_test_file(file_path)
	if not file_path or file_path == "" then
		return false
	end

	if not file_path:match("[/\\]test[/\\].+%.test%.[mc]?[jt]sx?$") then
		return false
	end

	local package_json = vim.fs.find("package.json", {
		path = vim.fs.dirname(file_path),
		upward = true,
	})[1]

	return package_json and package_json_has_dependency(package_json, "mocha") or false
end

local function get_neotest_client()
	local _, client = debug.getupvalue(neotest.run.get_tree_from_args, 1)
	return client
end

local function ensure_test_positions(file_path)
	local client = get_neotest_client()
	if not client or not file_path or file_path == "" then
		return
	end

	local adapter_id = client:get_adapter(file_path)
	if not adapter_id then
		client:_update_adapters(vim.fs.dirname(file_path))
		adapter_id = client:get_adapter(file_path)
	end

	if adapter_id and not client:get_position(file_path, { adapter = adapter_id }) then
		client:_update_positions(file_path, { adapter = adapter_id })
	end
end

local function run_nearest_test()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		ensure_test_positions(file_path)

		local tree = neotest.run.get_tree_from_args(nil, false)
		if tree then
			neotest.run.run()
			return
		end

		neotest.run.run(file_path)
	end)
end

local function run_file_tests()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		ensure_test_positions(file_path)
		neotest.run.run(file_path)
	end)
end

local function run_project_tests()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		local root = find_package_root(file_path) or vim.fn.getcwd()
		ensure_test_positions(file_path)
		neotest.run.run(root)
	end)
end

local function toggle_test_summary()
	nio.run(function()
		ensure_test_positions(vim.fn.expand("%:p"))
		neotest.summary.toggle()
	end)
end

local function has_test_support(file_path)
	return is_jest_test_file(file_path) or is_mocha_test_file(file_path)
end

local function with_test_support(fn)
	return function()
		local file_path = vim.fn.expand("%:p")
		if not has_test_support(file_path) then
			vim.notify("Test mappings are only available in supported Jest or Mocha test buffers.", vim.log.levels.INFO)
			return
		end

		fn()
	end
end

vim.keymap.set("n", "<leader>t?", function()
	vim.notify("Test mappings are available in supported JavaScript/TypeScript test buffers for Jest or Mocha projects.")
end, { desc = "Test Mapping Help" })
vim.keymap.set("n", "<leader>tn", with_test_support(run_nearest_test), { desc = "Run Nearest Test" })
vim.keymap.set("n", "<leader>tf", with_test_support(run_file_tests), { desc = "Run File Tests" })
vim.keymap.set("n", "<leader>ta", with_test_support(run_project_tests), { desc = "Run All Tests" })
vim.keymap.set("n", "<leader>ts", with_test_support(toggle_test_summary), { desc = "Toggle Test Summary" })
vim.keymap.set("n", "<leader>to", with_test_support(function()
	neotest.output.open({ enter = true })
end), { desc = "Open Test Output" })

neotest.setup({
	summary = {
		animated = false,
		follow = false,
		mappings = {
			expand = { "<CR>", "l" },
			parent = "h",
			output = "o",
			short = "O",
			attach = "a",
			jumpto = "i",
			stop = "u",
			run = "r",
			mark = "m",
			run_marked = "R",
			clear_marked = "M",
			target = "t",
			clear_target = "T",
			next_failed = "J",
			prev_failed = "K",
			watch = "w",
			help = "?",
		},
	},
	adapters = {
		require("neotest-jest")({
			jestCommand = function(file_path)
				current_test_path = file_path
				return get_jest_command(file_path)
			end,
			jestConfigFile = function(file_path)
				current_test_path = file_path
				return find_jest_config(file_path) or "jest.config.js"
			end,
			cwd = function(file_path)
				current_test_path = file_path
				local config = find_jest_config(file_path)
				return config and vim.fs.dirname(config) or vim.fn.getcwd()
			end,
			env = function(spec_env)
				return vim.tbl_extend("force", load_jest_env(current_test_path), spec_env)
			end,
			isTestFile = is_jest_test_file,
		}),
		require("plugins.neotest.mocha_adapter")({
			command = function(path)
				current_mocha_path = path
				return find_project_binary(path, "mocha") or "mocha"
			end,
			command_args = function(context)
				local args = {
					"--full-trace",
					"--reporter=json",
					"--reporter-options=output=" .. context.results_path,
					"--grep=" .. context.test_name_pattern,
				}

				local stat = vim.uv.fs_stat(context.path)
				if stat and stat.type ~= "directory" then
					table.insert(args, context.path)
				end

				return args
			end,
			cwd = function(path)
				current_mocha_path = path
				return find_package_root(path) or vim.fn.getcwd()
			end,
			env = function(spec_env)
				return vim.tbl_extend("force", load_mocha_env(current_mocha_path), spec_env)
			end,
			is_test_file = is_mocha_test_file,
		}),
	},
})
