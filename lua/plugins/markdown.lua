vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/iamcco/markdown-preview.nvim",
})

require("render-markdown").setup(require("plugins.markdown.render_opts"))

vim.keymap.set("n", "<leader>mm", function()
	local rm = require("render-markdown")
	local enabled = require("render-markdown.state").enabled
	if enabled then
		rm.disable()
	else
		rm.enable()
	end
end, { desc = "Toggle Render Markdown" })

vim.keymap.set("n", "<leader>mp", function()
	vim.fn["mkdp#util#install"]()
	vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown preview" })
