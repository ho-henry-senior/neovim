local project = require("plugins.neotest.project")

local M = {}

local root_markers = {
	"pyproject.toml",
	"pytest.ini",
	"setup.cfg",
	"tox.ini",
	"requirements.txt",
	".git",
}

function M.project_root(file_path)
	local marker = project.find_file(file_path, root_markers)
	return marker and vim.fs.dirname(marker) or nil
end

local function is_python_test_name(file_path)
	local name = vim.fs.basename(file_path)
	return name:match("^test_.*%.py$") ~= nil or name:match(".*_test%.py$") ~= nil
end

function M.is_test_file(file_path)
	if not file_path or file_path == "" or not file_path:match("%.py$") then
		return false
	end

	return is_python_test_name(file_path) or file_path:match("[/\\]tests[/\\].+%.py$") ~= nil
end

local function python_path(file_path)
	local root = M.project_root(file_path) or vim.fn.getcwd()
	for _, path in ipairs({
		root .. "/.venv/bin/python",
		root .. "/venv/bin/python",
	}) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end

	return "python"
end

function M.adapters()
	local adapter = require("neotest-python")({
		runner = "unittest",
		python = python_path,
		is_test_file = M.is_test_file,
	})

	adapter.root = M.project_root

	return {
		adapter,
	}
end

return M
