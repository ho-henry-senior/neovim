-- Install with: dotnet tool install --global csharp-ls

---@type vim.lsp.Config
return {
	cmd = { "csharp-ls" },
	filetypes = { "cs" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(fname, function(name)
			return name:match("%.slnx?$") ~= nil
		end) or vim.fs.root(fname, function(name)
			return name:match("%.csproj$") ~= nil
		end) or vim.fs.root(fname, ".git")

		on_dir(root)
	end,
}
