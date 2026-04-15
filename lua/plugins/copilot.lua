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
require("CopilotChat").setup()

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

vim.keymap.set("n", "<leader>aA", "<cmd>Copilot auth<cr>", { desc = "Auth" })
vim.keymap.set("n", "<leader>at", "<cmd>Copilot toggle<cr>", { desc = "Toggle" })
vim.keymap.set("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Status" })

vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChat<cr>", { desc = "Chat" })

vim.keymap.set("n", "<leader>aa", function()
	require("CopilotChat").ask("Explain this code", {
		sticky = { "#buffer" },
	})
end, { desc = "Explain Buffer" })

vim.keymap.set("v", "<leader>aa", function()
	require("CopilotChat").ask("Explain this code")
end, { desc = "Explain Selection" })
