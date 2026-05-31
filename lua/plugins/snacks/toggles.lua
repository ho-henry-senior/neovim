local M = {}

function M.setup(Snacks)
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.schedule(function()
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle
					.option("showtabline", {
						off = 0,
						on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
						name = "Tabline",
					})
					:map("<leader>ua")
				Snacks.toggle.treesitter():map("<leader>ut")
				Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
				Snacks.toggle.indent():map("<leader>ug")
			end)
		end,
	})
end

return M
