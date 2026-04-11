---@type vim.lsp.Config
return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars" },
	root_dir = function(fname)
		return vim.fs.root(fname, {
			".terraform",
			".terraform.lock.hcl",
			".git",
		})
	end,
}
