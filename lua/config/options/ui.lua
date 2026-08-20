local utils = require("lib.utils")
local augroup = utils.augroup
local get_hl = utils.get_hl
local blend_colors = utils.blend_colors
local opt = vim.opt

local function apply_inactive_window_highlights()
	local normal = get_hl("Normal")
	local comment = get_hl("Comment")
	local line_nr = get_hl("LineNr")
	local muted_fg = comment.fg or line_nr.fg or normal.fg
	local inactive_bg = (normal.bg and muted_fg) and blend_colors(normal.bg, muted_fg, 0.12) or normal.bg

	if not muted_fg then
		return
	end

	vim.api.nvim_set_hl(0, "NormalNC", {
		bg = inactive_bg,
		fg = normal.fg,
	})
	vim.api.nvim_set_hl(0, "SignColumnNC", {
		bg = inactive_bg,
	})
	vim.api.nvim_set_hl(0, "LineNrNC", {
		bg = inactive_bg,
		fg = line_nr.fg or muted_fg,
	})
end

local function apply_gitsigns_inline_highlights()
	local normal = get_hl("Normal")
	if not normal.bg then
		return
	end

	local function inline_hl(signal_group)
		local signal = get_hl(signal_group)
		local color = signal.fg or normal.fg
		if not color then
			return nil
		end
		return {
			bg = blend_colors(normal.bg, color, 0.35),
			fg = normal.fg,
		}
	end

	local groups = {
		GitSignsAddInline = inline_hl("Added"),
		GitSignsChangeInline = inline_hl("Changed"),
		GitSignsDeleteInline = inline_hl("Removed"),
	}

	for name, hl in pairs(groups) do
		if hl then
			vim.api.nvim_set_hl(0, name, hl)
		end
	end
end

opt.number = true -- Line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
vim.opt.guicursor = table.concat({ -- Blinking cursor definitions for different modes.
	"n-v-c:block-blinkon250-blinkoff250",
	"i-ci:ver25-blinkon250-blinkoff250",
	"r-cr:hor20-blinkon250-blinkoff250",
}, ",")

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
vim.cmd.colorscheme("retrobox")
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.showmode = false -- Don't show mode in command line
opt.winblend = 0 -- Floating window transparency
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.concealcursor = "" -- Don't hide cursor line markup
opt.ruler = false -- Disable the default ruler
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = false -- Show some invisible characters (tabs...)
opt.shortmess:append({ W = true, I = true, c = true, C = true })

apply_inactive_window_highlights()
apply_gitsigns_inline_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup("inactive_window_highlights"),
	callback = function()
		vim.schedule(function()
			apply_inactive_window_highlights()
			apply_gitsigns_inline_highlights()
		end)
	end,
})
