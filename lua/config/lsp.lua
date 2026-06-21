-- LSP
local augroup = require("lib.utils").augroup

local default_keymaps = {
	{ keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code actions" },
	{
		keys = "<leader>cl",
		func = function()
			if vim.fn.exists(":LspOxlintFixAll") > 0 then
				vim.cmd("LspOxlintFixAll")
			elseif vim.fn.exists(":LspEslintFixAll") > 0 then
				vim.cmd("LspEslintFixAll")
			else
				vim.lsp.buf.code_action({
					apply = true,
					context = { only = { "source.fixAll" }, diagnostics = {} },
				})
			end
		end,
		desc = "LSP fix all",
	},
	{ keys = "K", func = vim.lsp.buf.hover, desc = "Hover (alt)", has = "hoverProvider" },
	{ keys = "gd", func = vim.lsp.buf.definition, desc = "Goto definition", has = "definitionProvider" },
	{
		keys = "<leader>qr",
		func = function()
			vim.lsp.buf.references(nil, {
				on_list = function(options)
					vim.fn.setqflist({}, "r", { title = options.title, items = options.items })
					vim.cmd("copen")
				end,
			})
		end,
		desc = "References → quickfix",
		has = "referencesProvider",
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buf = args.buf
		if client then
			if client.name == "ruff" then
				client.server_capabilities.hoverProvider = false
			end

			if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				vim.lsp.inlay_hint.enable(true, { bufnr = buf })

				if not vim.b[buf].inlay_hints_autocmd_set then
					vim.api.nvim_create_autocmd("InsertEnter", {
						buffer = buf,
						callback = function()
							vim.lsp.inlay_hint.enable(false, { bufnr = buf })
						end,
					})
					vim.api.nvim_create_autocmd("InsertLeave", {
						buffer = buf,
						callback = function()
							vim.lsp.inlay_hint.enable(true, { bufnr = buf })
						end,
					})
					vim.b[buf].inlay_hints_autocmd_set = true
				end
			end

			if client:supports_method("textDocument/documentColor") then
				vim.lsp.document_color.enable(true, {
					bufnr = buf,
					style = "virtual",
				})
			end

			for _, km in ipairs(default_keymaps) do
				-- Only bind if there's no `has` requirement, or the server supports it
				if not km.has or client.server_capabilities[km.has] then
					vim.keymap.set(
						km.mode or "n",
						km.keys,
						km.func,
						{ buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
					)
				end
			end
		end
	end,
})

vim.lsp.enable({
	"bash_ls", -- Bash
	"csharp_ls", -- C# / .NET
	"css_ls", -- CSS
	"harper_ls", -- Spell checking
	"html_ls", -- HTML
	"json_ls", -- JSON
	"lua_ls", -- Lua
	"marksman_ls", -- Markdown
	"pyright_ls", -- Python
	"ruff", -- Python linting and Ruff code actions
	"terraform_ls", -- Terraform
	"ts_ls", -- JS / TS
	"yaml_ls", -- YAML
})
