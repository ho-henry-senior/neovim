local M = {}

function M.keys()
	return {
		{
			lhs = "<leader>ud",
			desc = "Diagnostics toggle",
			callback = function()
				require("snacks").toggle.diagnostics():toggle()
			end,
		},
		{
			lhs = "<leader>ua",
			desc = "Tabline toggle",
			callback = function()
				require("snacks").toggle
					.option("showtabline", {
						off = 0,
						on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
						name = "Tabline",
					})
					:toggle()
			end,
		},
		{
			lhs = "<leader>ut",
			desc = "Treesitter toggle",
			callback = function()
				require("snacks").toggle.treesitter():toggle()
			end,
		},
		{
			lhs = "<leader>ub",
			desc = "Dark background toggle",
			callback = function()
				require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):toggle()
			end,
		},
		{
			lhs = "<leader>ug",
			desc = "Indent guides toggle",
			callback = function()
				require("snacks").toggle.indent():toggle()
			end,
		},
	}
end

return M
