local jest = require("plugins.neotest.jest")
local mocha = require("plugins.neotest.mocha")
local project = require("plugins.neotest.project")

local M = {}

function M.is_test_file(file_path)
	return jest.is_test_file(file_path) or mocha.is_test_file(file_path)
end

function M.project_root(file_path)
	return project.find_package_root(file_path)
end

function M.adapters()
	return {
		jest.adapter(),
		mocha.adapter(),
	}
end

return M
