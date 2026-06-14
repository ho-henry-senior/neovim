local keys = require("plugins.snacks.keymaps").keys()
vim.list_extend(keys, require("plugins.snacks.toggles").keys())

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
		keys = keys,
		config = function()
			local Snacks = require("snacks")

			Snacks.setup(require("plugins.snacks.config"))
			Snacks.input.enable()
			vim.ui.select = Snacks.picker.select
		end,
	},
}
