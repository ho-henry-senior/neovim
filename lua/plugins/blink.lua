return {
	{
		src = "https://github.com/saghen/blink.cmp",
		name = "blink.cmp",
		version = vim.version.range("^1"),
		event = "InsertEnter",
		main = "blink.cmp",
		opts = {
			keymap = { preset = "super-tab" },
			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = true,
			},
			completion = {
				documentation = { auto_show = true },
			},
			sources = {
				default = { "lsp", "path", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
