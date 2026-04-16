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

local function load_project_env(file_path)
	local env = vim.fn.environ()
	if not file_path or file_path == "" then
		return env
	end

	local env_files = vim.fs.find({ ".env.test.local", ".env.test", ".env.local", ".env" }, {
		path = vim.fs.dirname(file_path),
		upward = true,
	})

	for i = #env_files, 1, -1 do
		env = vim.tbl_extend("force", env, parse_dotenv(env_files[i]))
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
				return vim.tbl_extend("force", load_project_env(current_test_path), spec_env)
			end,
			isTestFile = is_jest_test_file,
		}),
	},
})

vim.keymap.set("n", "<leader>tn", function()
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
end, { desc = "Run Nearest Test" })

vim.keymap.set("n", "<leader>tf", function()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		ensure_test_positions(file_path)
		neotest.run.run(file_path)
	end)
end, { desc = "Run File Tests" })

vim.keymap.set("n", "<leader>ta", function()
	neotest.run.run(vim.fn.getcwd())
end, { desc = "Run All Tests" })

vim.keymap.set("n", "<leader>ts", function()
	nio.run(function()
		ensure_test_positions(vim.fn.expand("%:p"))
		neotest.summary.toggle()
	end)
end, { desc = "Toggle Test Summary" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({ enter = true })
end, { desc = "Open Test Output" })
