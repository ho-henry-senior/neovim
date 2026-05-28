vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

local wk = require("which-key")

wk.setup({
	preset = "classic",
	icons = { mappings = false },
})

-- groups
wk.add({
	{ "<leader><tab>", group = "tabs" },
	{ "<leader>a", group = "ai" },
	{ "<leader>b", group = "buffers" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>f", group = "files" },
	{ "<leader>fC", group = "path" },
	{ "<leader>g", group = "git" },
	{ "<leader>gh", group = "hunks" },
	{ "<leader>m", group = "markdown" },
	{ "<leader>p", group = "plugins" },
	{ "<leader>q", group = "session" },
	{ "<leader>r", group = "requests" },
	{ "<leader>s", group = "search" },
	{ "<leader>t", group = "test" },
	{ "<leader>u", group = "ui" },
	{ "<leader>x", group = "diagnostics" },
})

-- dynamic group

-- mappings
wk.add({
	{ "gx", desc = "Open With System App" },

	{
		"<leader>fCf",
		function()
			local p = vim.fn.expand("%:p")
			vim.fn.setreg("+", p)
			vim.notify("Copied full file path: " .. p)
		end,
		desc = "Copy Full Path",
	},
	{
		"<leader>fCn",
		function()
			local n = vim.fn.expand("%:t")
			vim.fn.setreg("+", n)
			vim.notify("Copied file name: " .. n)
		end,
		desc = "Copy File Name",
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
		desc = "Copy Relative Path",
	},

	{
		"<leader>?",
		function()
			wk.show({ global = false })
		end,
		desc = "Show Buffer Keymaps",
	},
})
