return {
	{
		src = "https://github.com/MagicDuck/grug-far.nvim",
		name = "grug-far.nvim",
		lazy = true,
		opts = {
			headerMaxWidth = 80,
		},
		module = "grug-far",
		keys = {
			{
				mode = { "n", "v", "x" },
				lhs = "<leader>sr",
				desc = "Search and replace",
				callback = function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
			},
		},
	},
}
