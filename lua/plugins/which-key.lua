return {
	{
		src = "https://github.com/folke/which-key.nvim",
		name = "which-key.nvim",
		opts = {
			preset = "classic",
			icons = { mappings = false },
		},
		config = function(spec, opts)
			local wk = require("which-key")

			wk.setup(opts)

			wk.add({
				{ "<leader>a", group = "ai" },
				{ "<leader>q", group = "quickfix" },
				{ "<leader>b", group = "buffers" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "files" },
				{ "<leader>fc", group = "copy path" },
				{ "<leader>g", group = "git" },
				{ "<leader>i", group = "inspect" },
				{ "<leader>m", group = "markdown" },
				{ "<leader>p", group = "plugins" },
				{ "<leader>S", group = "session" },
				{ "<leader>r", group = "rest" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "test" },
				{ "<leader>u", group = "ui" },
			})

			wk.add({
				{ "gx", desc = "Open with system app" },

				{
					"<leader>fcf",
					function()
						local p = vim.fn.expand("%:p")
						vim.fn.setreg("+", p)
						vim.notify("Copied full file path: " .. p)
					end,
					desc = "Copy full path",
				},
				{
					"<leader>fcn",
					function()
						local n = vim.fn.expand("%:t")
						vim.fn.setreg("+", n)
						vim.notify("Copied file name: " .. n)
					end,
					desc = "Copy file name",
				},
				{
					"<leader>fcr",
					function()
						local cwd = vim.fn.getcwd()
						local full = vim.fn.expand("%:p")
						local rel = full:sub(#cwd + 2)
						vim.fn.setreg("+", rel)
						vim.notify("Copied relative path: " .. rel)
					end,
					desc = "Copy relative path",
				},

				{
					"<leader>?",
					function()
						wk.show({ global = false })
					end,
					desc = "Show buffer keymaps",
				},
			})
		end,
	},
}
