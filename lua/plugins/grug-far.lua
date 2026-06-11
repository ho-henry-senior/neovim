local M = {}

function M.setup()
	if M._did_setup then
		return
	end

	vim.pack.add({
		"https://github.com/MagicDuck/grug-far.nvim",
	})

	require("grug-far").setup({
		headerMaxWidth = 80,
	})

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

	M._did_setup = true
end

return M
