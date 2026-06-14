return {
	{
		src = "https://github.com/folke/snacks.nvim",
		name = "snacks.nvim",
		dependencies = {
			{
				src = "https://github.com/nvim-tree/nvim-web-devicons",
				name = "nvim-web-devicons",
			},
		},
		config = function()
			local Snacks = require("snacks")

			Snacks.setup(require("plugins.snacks.config"))
			Snacks.input.enable()
			vim.ui.select = Snacks.picker.select
			require("plugins.snacks.toggles").setup(Snacks)
			require("plugins.snacks.keymaps").setup(Snacks)
		end,
	},
}
