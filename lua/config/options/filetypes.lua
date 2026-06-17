vim.g.markdown_recommended_style = 0

vim.filetype.add({
	extension = {
		env = "dotenv",
		txt = "markdown",
		njk = "html",
		mermaid = "mermaid",
		mmd = "mermaid",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
