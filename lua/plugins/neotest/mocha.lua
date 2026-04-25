local env = require("plugins.neotest.env")
local project = require("plugins.neotest.project")

local M = {}

local current_test_path = nil

function M.is_test_file(file_path)
	if not file_path or file_path == "" then
		return false
	end

	if not file_path:match("[/\\]test[/\\].+%.test%.[mc]?[jt]sx?$") then
		return false
	end

	local package_json = project.find_package_json(file_path)
	return package_json and project.package_json_has_dependency(package_json, "mocha") or false
end

function M.adapter()
	return require("plugins.neotest.mocha_adapter")({
		command = function(path)
			current_test_path = path
			return project.find_project_binary(path, "mocha") or "mocha"
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
			current_test_path = path
			return project.find_package_root(path) or vim.fn.getcwd()
		end,
		env = function(spec_env)
			return vim.tbl_extend("force", env.load_mocha(current_test_path), spec_env)
		end,
		is_test_file = M.is_test_file,
	})
end

return M
