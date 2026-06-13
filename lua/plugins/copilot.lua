local M = {}

function M.setup()
	if M._did_setup then
		return
	end

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
			enabled = true,
			keymap = {
				refresh = false,
			},
		},
	})

	require("CopilotChat").setup({
		model = "auto",
	})

	local function refresh_copilot_panel()
		local panel_name = vim.api.nvim_buf_get_name(0)
		local source_name = panel_name:gsub("^copilot://", "")

		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local bufnr = vim.api.nvim_win_get_buf(win)
			if vim.api.nvim_buf_get_name(bufnr) == source_name then
				vim.api.nvim_win_call(win, function()
					require("copilot.panel").refresh()
				end)
				return
			end
		end

		vim.notify("Could not find Copilot panel source buffer", vim.log.levels.WARN)
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "copilot://*",
		callback = function(args)
			vim.keymap.set("n", "R", refresh_copilot_panel, {
				buffer = args.buf,
				desc = "Copilot panel refresh",
				silent = true,
			})
		end,
	})

	local function toggle_copilot()
		if require("copilot.client").is_disabled() then
			vim.cmd("Copilot enable")
			vim.notify("Copilot enabled", vim.log.levels.INFO)
		else
			vim.cmd("Copilot disable")
			vim.notify("Copilot disabled", vim.log.levels.WARN)
		end
	end

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

	vim.keymap.set("n", "<leader>aA", "<cmd>Copilot auth<cr>", { desc = "Copilot authenticate" })
	vim.keymap.set("n", "<leader>at", toggle_copilot, { desc = "Copilot toggle" })
	vim.keymap.set("n", "<leader>aT", "<cmd>Copilot toggle<cr>", { desc = "Copilot buffer toggle" })
	vim.keymap.set("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Copilot status" })
	vim.keymap.set("n", "<leader>ap", "<cmd>Copilot panel toggle<cr>", { desc = "Copilot panel toggle" })

	vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChat<cr>", { desc = "Copilot chat" })

	vim.keymap.set("n", "<leader>aa", function()
		require("CopilotChat").ask("Explain this code", {
			sticky = { "#buffer" },
		})
	end, { desc = "Copilot explain buffer" })

	vim.keymap.set("v", "<leader>aa", function()
		require("CopilotChat").ask("Explain this code")
	end, { desc = "Copilot explain selection" })

	M._did_setup = true
end

return M
