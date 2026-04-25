local project = require("plugins.neotest.project")

local M = {}

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

function M.load_files(file_path, file_names)
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

function M.load_jest(file_path)
	return M.load_files(file_path, { ".env.test.local", ".env.test", ".env.local", ".env" })
end

function M.load_mocha(file_path)
	local env = M.load_files(file_path, { ".env.dev", ".env.local", ".env" })
	local package_root = project.find_package_root(file_path)
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

return M
