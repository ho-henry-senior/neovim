-- Install with: uv tool install ruff

---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	-- Keep Python LSPs rooted at the exercise's python/ directory in this multi-language repo.
	root_dir = require("lsp.python_root").root_dir,
}
