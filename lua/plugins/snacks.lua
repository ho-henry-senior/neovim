vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")

Snacks.setup(require("plugins.snacks.config"))
require("plugins.snacks.toggles").setup(Snacks)
require("plugins.snacks.keymaps").setup(Snacks)
