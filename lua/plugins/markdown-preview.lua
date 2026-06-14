return {
	{
		src = "https://github.com/iamcco/markdown-preview.nvim",
		name = "markdown-preview.nvim",
		init = function()
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_preview_options = vim.tbl_deep_extend("force", vim.g.mkdp_preview_options or {}, {
				maid = {},
			})
		end,
		cmd = "MarkdownPreviewToggle",
		keys = {
			{
				lhs = "<leader>mp",
				desc = "Markdown preview toggle",
				cmd = "MarkdownPreviewToggle",
			},
		},
	},
}
