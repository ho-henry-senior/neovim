local M = {}

local function search_path(path)
	if not path or path == "" then
		return nil
	end

	local stat = vim.uv.fs_stat(path)
	return stat and stat.type == "directory" and path or vim.fs.dirname(path)
end

function M.find_file(path, names)
	local start = search_path(path)
	if not start then
		return nil
	end

	return vim.fs.find(names, {
		path = start,
		upward = true,
	})[1]
end

function M.find_package_json(path)
	return M.find_file(path, "package.json")
end

function M.find_package_root(path)
	local package_json = M.find_package_json(path)
	return package_json and vim.fs.dirname(package_json) or nil
end

function M.read_json(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	local ok, parsed = pcall(vim.json.decode, content)
	return ok and type(parsed) == "table" and parsed or nil
end

function M.package_json_has_dependency(package_json_path, package_name)
	local package_json = M.read_json(package_json_path)
	if not package_json then
		return false
	end

	for _, field in ipairs({ "dependencies", "devDependencies" }) do
		local deps = package_json[field]
		if type(deps) == "table" and deps[package_name] then
			return true
		end
	end

	return false
end

function M.package_json_has_script_command(package_json_path, command_name)
	local package_json = M.read_json(package_json_path)
	if not package_json then
		return false
	end

	local scripts = package_json.scripts
	if type(scripts) ~= "table" then
		return false
	end

	for _, command in pairs(scripts) do
		if type(command) == "string" and command:match("%f[%w]" .. command_name .. "%f[%W]") then
			return true
		end
	end

	return false
end

function M.package_json_has_tool(package_json_path, tool_name)
	return M.package_json_has_dependency(package_json_path, tool_name)
		or M.package_json_has_script_command(package_json_path, tool_name)
end

function M.find_project_binary(path, binary_name)
	local root = M.find_package_root(path)
	if not root then
		return nil
	end

	local binary = root .. "/node_modules/.bin/" .. binary_name
	return vim.fn.executable(binary) == 1 and binary or nil
end

function M.is_generated_path(path)
	return path:match("/dist/") or path:match("/build/") or path:match("/coverage/")
end

return M
