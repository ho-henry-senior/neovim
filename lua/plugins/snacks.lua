local M = {}

function M.setup()
	if M._did_setup then
		return
	end

	vim.pack.add({
		"https://github.com/folke/snacks.nvim",
		"https://github.com/nvim-tree/nvim-web-devicons",
	})

	local Snacks = require("snacks")

	Snacks.setup(require("plugins.snacks.config"))
	require("plugins.snacks.toggles").setup(Snacks)
	require("plugins.snacks.keymaps").setup(Snacks)

	M._did_setup = true
end

return M
