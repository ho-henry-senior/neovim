local javascript = require("plugins.neotest.javascript")
local dotnet = require("plugins.neotest.dotnet")
local python = require("plugins.neotest.python")

local M = {}

local languages = {
	javascript,
	dotnet,
	python,
}

function M.is_test_file(file_path)
	for _, language in ipairs(languages) do
		if language.is_test_file(file_path) then
			return true
		end
	end

	return false
end

function M.project_root(file_path)
	for _, language in ipairs(languages) do
		local root = language.project_root(file_path)
		if root then
			return root
		end
	end

	return nil
end

function M.adapters()
	local adapters = {}
	for _, language in ipairs(languages) do
		vim.list_extend(adapters, language.adapters())
	end

	return adapters
end

return M
