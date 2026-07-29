-- Install with: brew install marksman
return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown" },
	root_markers = { ".marksman.toml", ".git" },
	single_file_support = true,
}
