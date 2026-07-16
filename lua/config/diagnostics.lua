--- diagnostic settings
local map = vim.keymap.set
local palette = {
	err = "#51202A",
	warn = "#3B3B1B",
	info = "#1F3342",
	hint = "#1E2E1E",
}

vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.err, blend = 20 })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine", { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine", { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, "DiagnosticHintLine", { bg = palette.hint, blend = 10 })

local sev = vim.diagnostic.severity

vim.diagnostic.config({
	-- keep underline & severity_sort on for quick scanning
	underline = true,
	severity_sort = true,
	update_in_insert = false, -- less flicker

	float = {
		border = "rounded",
		source = true,
	},

	-- keep signs & virtual text, but tune them as you like
	signs = {
		text = {
			[sev.ERROR] = " ",
			[sev.WARN] = " ",
			[sev.INFO] = " ",
			[sev.HINT] = "󰌵 ",
		},
	},
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},

	linehl = {
		[sev.ERROR] = "DiagnosticErrorLine",
	},
})

-- diagnostic keymaps
local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({
			count = next and 1 or -1,
			severity = severity,
			on_jump = function(diagnostic)
				if diagnostic then
					vim.diagnostic.open_float()
				end
			end,
		})
	end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

map("n", "<leader>qd", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "All diagnostics → quickfix" })

map("n", "<leader>qe", function()
	vim.diagnostic.setqflist({ open = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Errors → quickfix" })

map("n", "<leader>uv", function()
	local vt = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not vt })
end, { desc = "LSP text toggle" })
