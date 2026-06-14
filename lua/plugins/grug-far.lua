return {
	{
		src = "https://github.com/MagicDuck/grug-far.nvim",
		name = "grug-far.nvim",
		opts = {
			headerMaxWidth = 80,
		},
		module = "grug-far",
		config = function(spec, opts)
			require(spec.module).setup(opts)

			vim.keymap.set({ "n", "v", "x" }, "<leader>sr", function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end, { desc = "Search and replace" })
		end,
	},
}
