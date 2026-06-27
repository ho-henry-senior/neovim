local function toggle_copilot()
	if require("copilot.client").is_disabled() then
		vim.cmd("Copilot enable")
		vim.notify("Copilot enabled", vim.log.levels.INFO)
	else
		vim.cmd("Copilot disable")
		vim.notify("Copilot disabled", vim.log.levels.WARN)
	end
end

return {
	{
		src = "https://github.com/zbirenbaum/copilot.lua",
		name = "copilot.lua",
		opts = {
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
		},
		module = "copilot",
		event = "InsertEnter",
		cmd = {
			"Copilot",
		},
		keys = {
			{
				mode = "i",
				lhs = "<C-l>",
				callback = function()
					require("copilot.suggestion").accept()
				end,
			},
			{
				mode = "i",
				lhs = "<C-j>",
				callback = function()
					require("copilot.suggestion").next()
				end,
			},
			{
				mode = "i",
				lhs = "<C-k>",
				callback = function()
					require("copilot.suggestion").prev()
				end,
			},
			{
				mode = "i",
				lhs = "<C-h>",
				callback = function()
					require("copilot.suggestion").dismiss()
				end,
			},
			{
				lhs = "<leader>aA",
				desc = "Copilot authenticate",
				cmd = "Copilot auth",
			},
			{
				lhs = "<leader>at",
				desc = "Copilot toggle",
				callback = toggle_copilot,
			},
			{
				lhs = "<leader>aT",
				desc = "Copilot buffer toggle",
				cmd = "Copilot toggle",
			},
			{
				lhs = "<leader>as",
				desc = "Copilot status",
				cmd = "Copilot status",
			},
			{
				lhs = "<leader>ap",
				desc = "Copilot panel toggle",
				cmd = "Copilot panel toggle",
			},
		},
		config = function(spec, opts)
			require(spec.module).setup(opts)

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
						buf = args.buf,
						desc = "Copilot panel refresh",
						silent = true,
					})
				end,
			})
		end,
	},
}
