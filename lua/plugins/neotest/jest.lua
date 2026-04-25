local env = require("plugins.neotest.env")
local project = require("plugins.neotest.project")
local jest_path_util = require("neotest-jest.util")
local jest_util = require("neotest-jest.jest-util")

local M = {}

local config_names = {
	"jest.config.js",
	"jest.config.cjs",
	"jest.config.mjs",
	"jest.config.ts",
}

local current_test_path = nil

function M.find_config(path)
	return project.find_file(path, config_names)
end

function M.is_test_file(file_path)
	if not file_path or file_path == "" or project.is_generated_path(file_path) then
		return false
	end

	if not jest_path_util.defaultTestFileMatcher(file_path) then
		return false
	end

	if M.find_config(file_path) then
		return true
	end

	local package_json = project.find_package_json(file_path)
	return package_json and project.package_json_has_tool(package_json, "jest") or false
end

function M.adapter()
	return require("neotest-jest")({
		jestCommand = function(file_path)
			current_test_path = file_path
			-- Load dotenv before Jest starts so projects that read env vars at import
			-- time behave the same under neotest as they do under `node -r dotenv/config`.
			return ("node -r dotenv/config %s"):format(jest_util.getJestCommand(file_path))
		end,
		jestConfigFile = function(file_path)
			current_test_path = file_path
			return M.find_config(file_path) or "jest.config.js"
		end,
		cwd = function(file_path)
			current_test_path = file_path
			local config = M.find_config(file_path)
			return config and vim.fs.dirname(config) or vim.fn.getcwd()
		end,
		env = function(spec_env)
			return vim.tbl_extend("force", env.load_jest(current_test_path), spec_env)
		end,
		isTestFile = M.is_test_file,
	})
end

return M
