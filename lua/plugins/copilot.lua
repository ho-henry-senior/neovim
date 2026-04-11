vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
})

require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
	},
	panel = {
		enabled = false,
	},
})
vim.keymap.set("i", "<C-l>", function()
	require("copilot.suggestion").accept()
end, { silent = true })

vim.keymap.set("i", "<C-j>", function()
	require("copilot.suggestion").next()
end, { silent = true })

vim.keymap.set("i", "<C-k>", function()
	require("copilot.suggestion").prev()
end, { silent = true })

vim.keymap.set("i", "<C-h>", function()
	require("copilot.suggestion").dismiss()
end, { silent = true })

require("CopilotChat").setup()
