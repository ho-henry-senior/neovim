-- Install with: dotnet tool install --global csharp-ls
local csharp_ls = vim.fn.exepath("csharp-ls")
if csharp_ls == "" then
	csharp_ls = vim.fn.expand("~/.dotnet/tools/csharp-ls")
end

local homebrew_dotnet = "/opt/homebrew/opt/dotnet/libexec"
local dotnet_root = vim.env.DOTNET_ROOT or (vim.uv.fs_stat(homebrew_dotnet) and homebrew_dotnet) or nil

---@type vim.lsp.Config
return {
	cmd = { csharp_ls },
	cmd_env = dotnet_root and { DOTNET_ROOT = dotnet_root } or nil,
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
