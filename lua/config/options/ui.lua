local opt = vim.opt

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
