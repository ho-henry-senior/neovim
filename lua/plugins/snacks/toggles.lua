local M = {}

function M.setup(Snacks)
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.schedule(function()
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", {
						off = 0,
						on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
						name = "Conceal Level",
					})
					:map("<leader>uc")
				Snacks.toggle
					.option("showtabline", {
						off = 0,
						on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
						name = "Tabline",
					})
					:map("<leader>uA")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
				Snacks.toggle.indent():map("<leader>ug")
			end)
		end,
	})
end

return M
