-- Install with: dotnet tool install --global csharp-ls
local csharp_ls = vim.fn.exepath("csharp-ls")
if csharp_ls == "" then
	csharp_ls = vim.fn.expand("~/.dotnet/tools/csharp-ls")
end

---@type vim.lsp.Config
return {
	cmd = { csharp_ls },
	cmd_env = {
		DOTNET_ROOT = "/opt/homebrew/opt/dotnet/libexec",
	},
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
