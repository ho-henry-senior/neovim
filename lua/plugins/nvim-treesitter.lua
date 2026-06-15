return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		name = "nvim-treesitter",
		version = "main",
		config = function()
			local treesitter_runtime = vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime"
			if not vim.tbl_contains(vim.opt.runtimepath:get(), treesitter_runtime) then
				vim.opt.runtimepath:append(treesitter_runtime)
			end

			require("nvim-treesitter").setup({})
			require("nvim-treesitter").install({
				"bash",
				"css",
				"c_sharp",
				"diff",
				"dockerfile",
				"gitcommit",
				"gitignore",
				"html",
				"ini",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"luadoc",
				"luap",
				"make",
				"markdown",
				"markdown_inline",
				"mermaid",
				"nginx",
				"python",
				"query",
				"regex",
				"scss",
				"sql",
				"terraform",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			})

			vim.api.nvim_create_autocmd("PackChanged", {
				desc = "Handle nvim-treesitter updates",
				group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
				callback = function(event)
					if event.data.kind == "update" then
						local ok = pcall(vim.cmd, "TSUpdate")
						if ok then
							vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
						else
							vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
						end
					end
				end,
			})

			local SKIP_FT = {
				[""] = true,
				qf = true,
				help = true,
				man = true,
				notify = true,
				snacks_notif = true,
				snacks_notif_history = true,
				snacks_picker_list = true,
				snacks_picker_input = true,
				snacks_input = true,
				snacks_terminal = true,
				gitcommit = true,
				gitrebase = true,
				lspinfo = true,
				checkhealth = true,
				startuptime = true,
				TelescopePrompt = true,
				TelescopeResults = true,
				spectre_panel = true,
				["grug-far"] = true,
				trouble = true,
			}

			local function start_treesitter(buf)
				local ft = vim.bo[buf].filetype
				if SKIP_FT[ft] then
					return
				end

				local ok = pcall(vim.treesitter.start, buf)
				if not ok then
					return
				end

				for _, win in ipairs(vim.fn.win_findbuf(buf)) do
					vim.wo[win].foldmethod = "expr"
					vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end

				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "*" },
				callback = function(event)
					start_treesitter(event.buf)
				end,
			})

			vim.schedule(function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) then
						start_treesitter(buf)
					end
				end
			end)
		end,
	},
}
