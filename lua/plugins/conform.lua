-- Install prettier: npm install -g prettier
local function toggle_autoformat()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end

local function format_buffer()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end

return {
	{
		src = "https://github.com/stevearc/conform.nvim",
		name = "conform.nvim",
		event = { "BufReadPre", "BufNewFile", "SessionLoadPost" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
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
							"package.json",
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yaml",
							".prettierrc.yml",
							".prettierrc.toml",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
							"prettier.config.ts",
							"prettier.config.mts",
							"prettier.config.cts",
						}
						local project_config = nil
						for _, name in ipairs(config_files) do
							local found = vim.fn.findfile(name, search_dir .. ";")
							if found and found ~= "" then
								project_config = found
								break
							end
						end

						local args = { "--stdin-filepath", ctx.filename }
						local global_config = vim.fn.expand("~/.prettierrc")
						local config = project_config
						if not config and vim.fn.filereadable(global_config) == 1 then
							config = global_config
						end
						if config then
							vim.list_extend(args, { "--config", config })
						end

						return args
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
		},
		module = "conform",
		keys = {
			{
				lhs = "<leader>uf",
				desc = "Autoformat toggle",
				callback = toggle_autoformat,
			},
			{
				mode = { "n", "v" },
				lhs = "<leader>cf",
				desc = "Format buffer",
				callback = format_buffer,
			},
		},
		config = function(spec, opts)
			require(spec.module).setup(opts)

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
				vim.notify("Autoformat disabled" .. (args.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
			end, { desc = "Disable autoformat-on-save", bang = true })

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
				vim.notify("Autoformat enabled", vim.log.levels.INFO)
			end, { desc = "Re-enable autoformat-on-save" })
		end,
	},
}
