--- diagnostic settings
local map = vim.keymap.set
local utils = require("lib.utils")
local get_hl = utils.get_hl
local blend_colors = utils.blend_colors

local line_alphas = { Error = 0.20, Warn = 0.15, Info = 0.10, Hint = 0.10 }

local function apply_diagnostic_line_highlights()
	local normal = get_hl("Normal")
	if not normal.bg then
		return
	end

	for name, alpha in pairs(line_alphas) do
		local color = get_hl("Diagnostic" .. name).fg or normal.fg
		if color then
			vim.api.nvim_set_hl(0, "Diagnostic" .. name .. "Line", { bg = blend_colors(normal.bg, color, alpha) })
		end
	end
end

apply_diagnostic_line_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = utils.augroup("diagnostic_line_highlights"),
	callback = function()
		vim.schedule(apply_diagnostic_line_highlights)
	end,
})

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
