-- Install with: brew install marksman
return {
	cmd = { "marksman", "server" },
	cmd_env = {
		DOTNET_ROOT_ARM64 = "/opt/homebrew/opt/dotnet@9/libexec",
	},
	filetypes = { "markdown" },
	root_markers = { ".marksman.toml", ".git" },
	single_file_support = true,
}
