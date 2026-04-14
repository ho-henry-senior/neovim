vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

local wk = require("which-key")

wk.setup({
	preset = "modern",
})

-- groups
wk.add({
	{ "<leader><tab>", group = "tabs" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>D", group = "Diffview" },
	{ "<leader>dp", group = "profiler" },
	{ "<leader>f", group = "file/find" },
	{ "<leader>fC", group = "copy path" },
	{ "<leader>g", group = "git" },
	{ "<leader>gh", group = "hunks" },
	{ "<leader>q", group = "Session" },
	{ "<leader>s", group = "search" },
	{ "<leader>u", group = "ui" },
	{ "<leader>x", group = "diagnostics/quickfix" },
	{ "[", group = "prev" },
	{ "]", group = "next" },
	{ "g", group = "goto" },
	{ "gs", group = "surround" },
	{ "z", group = "fold" },
})

-- dynamic groups
wk.add({
	{
		"<leader>b",
		group = "buffer",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
})

-- mappings
wk.add({
	{ "gx", desc = "Open with system app" },

	{
		"<leader>fCf",
		function()
			local p = vim.fn.expand("%:p")
			vim.fn.setreg("+", p)
			vim.notify("Copied full file path: " .. p)
		end,
		desc = "Copy full path",
	},
	{
		"<leader>fCn",
		function()
			local n = vim.fn.expand("%:t")
			vim.fn.setreg("+", n)
			vim.notify("Copied file name: " .. n)
		end,
		desc = "Copy file name",
	},
	{
		"<leader>fCr",
		function()
			local cwd = vim.fn.getcwd()
			local full = vim.fn.expand("%:p")
			local rel = full:sub(#cwd + 2)
			vim.fn.setreg("+", rel)
			vim.notify("Copied relative path: " .. rel)
		end,
		desc = "Copy relative path",
	},

	{
		"<leader>?",
		function()
			wk.show({ global = false })
		end,
		desc = "Buffer keymaps",
	},
})
