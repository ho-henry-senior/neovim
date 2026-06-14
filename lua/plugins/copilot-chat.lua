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
		cmd = "CopilotChat",
		keys = {
			{
				lhs = "<leader>ac",
				desc = "Copilot chat",
				cmd = "CopilotChat",
			},
			{
				lhs = "<leader>aa",
				desc = "Copilot explain buffer",
				callback = function()
					require("CopilotChat").ask("Explain this code", {
						sticky = { "#buffer" },
					})
				end,
			},
			{
				mode = "v",
				lhs = "<leader>aa",
				desc = "Copilot explain selection",
				callback = function()
					require("CopilotChat").ask("Explain this code")
				end,
			},
		},
		config = function(spec, opts)
			require(spec.module).setup(opts)
		end,
	},
}
