return {
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
		name = "nvim-web-devicons",
	},
	{
		src = "https://github.com/folke/snacks.nvim",
		name = "snacks.nvim",
		config = function()
			local Snacks = require("snacks")

			Snacks.setup(require("plugins.snacks.config"))
			require("plugins.snacks.toggles").setup(Snacks)
			require("plugins.snacks.keymaps").setup(Snacks)
		end,
	},
}
