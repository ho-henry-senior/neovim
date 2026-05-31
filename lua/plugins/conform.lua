-- Install prettier: npm install -g prettier
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "black", stop_after_first = true },
		json = { "prettier" },
		jsonc = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettier" },
		vue = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		["markdown.mdx"] = { "prettier" },
		terraform = { "terraform_fmt" },
		graphql = { "prettier" },
		xml = { "xmllint" },
	},

	formatters = {
		prettier = {
			---@diagnostic disable-next-line: unused-local
			args = function(_self, ctx)
				local search_dir = ctx.dirname or vim.fn.getcwd()
				local config_files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"prettier.config.ts",
				}
				local project_config = nil
				for _, name in ipairs(config_files) do
					local found = vim.fn.findfile(name, search_dir .. ";")
					if found and found ~= "" then
						project_config = found
						break
					end
				end
				local config = project_config or vim.fn.expand("~/.prettierrc")
				return { "--config", config, "--stdin-filepath", ctx.filename }
			end,
		},
	},
	default_format_opts = { lsp_format = "fallback" },
	format_on_save = function(bufnr)
		local ignore_filetypes = { "sql" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(opts)
	if opts.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
	vim.notify("Autoformat disabled" .. (opts.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
	vim.notify("Autoformat enabled", vim.log.levels.INFO)
end, { desc = "Re-enable autoformat-on-save" })

local auto_format = true

vim.keymap.set("n", "<leader>uf", function()
	auto_format = not auto_format
	if auto_format then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end, { desc = "Toggle Autoformat" })

vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>ConformInfo<cr>", { desc = "Show Formatter Info" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { desc = "Format Buffer" })

vim.keymap.set({ "n", "v" }, "<leader>cF", function()
	require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Languages" })
