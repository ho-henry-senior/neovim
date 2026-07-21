local M = {}

-- Python exercises live inside per-language subdirectories, often without a
-- pyproject.toml. Prefer normal Python project markers, then fall back to the
-- current directory when it looks like a standalone exercise.
local project_markers = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"pyrightconfig.json",
}

function M.root_dir(bufnr, on_dir)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local root = vim.fs.root(fname, project_markers)

	if not root then
		local dir = vim.fs.dirname(fname)
		local has_python_sibling = false
		for name, type in vim.fs.dir(dir) do
			if type == "file" and name:match("%.py$") then
				has_python_sibling = true
				break
			end
		end

		if has_python_sibling then
			root = dir
		else
			root = vim.fs.root(fname, ".git")
		end
	end

	if root then
		on_dir(root)
	end
end

return M
