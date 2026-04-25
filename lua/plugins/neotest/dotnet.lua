local M = {}

local test_package_patterns = {
	"xunit",
	"nunit",
	"mstest",
	"Microsoft.NET.Test.Sdk",
}

local function find_upward(file_path, predicate)
	if not file_path or file_path == "" then
		return nil
	end

	local stat = vim.uv.fs_stat(file_path)
	local dir = stat and stat.type == "directory" and file_path or vim.fs.dirname(file_path)

	while dir and dir ~= "" do
		local handle = vim.uv.fs_scandir(dir)
		if handle then
			while true do
				local name = vim.uv.fs_scandir_next(handle)
				if not name then
					break
				end

				if predicate(name) then
					return dir .. "/" .. name
				end
			end
		end

		local parent = vim.fs.dirname(dir)
		if not parent or parent == dir then
			break
		end
		dir = parent
	end

	return nil
end

function M.project_root(file_path)
	local marker = find_upward(file_path, function(name)
		return name:match("%.slnx?$") ~= nil
	end) or find_upward(file_path, function(name)
		return name:match("%.csproj$") ~= nil
	end) or find_upward(file_path, function(name)
		return name == ".git"
	end)
	return marker and vim.fs.dirname(marker) or nil
end

local function find_csproj(file_path)
	return find_upward(file_path, function(name)
		return name:match("%.csproj$") ~= nil
	end)
end

local function csproj_has_test_reference(csproj)
	local file = io.open(csproj, "r")
	if not file then
		return false
	end

	local content = file:read("*a"):lower()
	file:close()

	for _, pattern in ipairs(test_package_patterns) do
		if content:find(pattern:lower(), 1, true) then
			return true
		end
	end

	return false
end

function M.is_test_file(file_path)
	if not file_path or file_path == "" or not file_path:match("%.cs$") then
		return false
	end

	local csproj = find_csproj(file_path)
	return csproj and csproj_has_test_reference(csproj) or false
end

function M.adapters()
	return {
		require("neotest-dotnet")({
			discovery_root = "solution",
		}),
	}
end

return M
