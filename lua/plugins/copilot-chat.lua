return {
	{
		src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
		name = "CopilotChat.nvim",
		dependencies = {
			{
				src = "https://github.com/nvim-lua/plenary.nvim",
				name = "plenary.nvim",
			},
		},
		opts = {
			model = "auto",
		},
		module = "CopilotChat",
		config = function(spec, opts)
			require(spec.module).setup(opts)

			vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChat<cr>", { desc = "Copilot chat" })

			vim.keymap.set("n", "<leader>aa", function()
				require("CopilotChat").ask("Explain this code", {
					sticky = { "#buffer" },
				})
			end, { desc = "Copilot explain buffer" })

			vim.keymap.set("v", "<leader>aa", function()
				require("CopilotChat").ask("Explain this code")
			end, { desc = "Copilot explain selection" })
		end,
	},
}
