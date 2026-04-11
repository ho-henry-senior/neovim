--Install with npm i -g typescript-language-server typescript

local ROOT_MARKERS = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }

return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.dirname(vim.fs.find(ROOT_MARKERS, { path = fname, upward = true })[1])
		on_dir(root or vim.fn.getcwd())
	end,
	settings = {
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				variableTypes = { enabled = false },
			},
		},
		javascript = {
			suggest = {
				completeFunctionCalls = true,
			},
		},
	},
}
