return {
	{
		src = "https://github.com/nvim-lualine/lualine.nvim",
		name = "lualine.nvim",
		dependencies = {
			{
				src = "https://github.com/nvim-tree/nvim-web-devicons",
				name = "nvim-web-devicons",
			},
		},
		config = function()
			local augroup = require("lib.utils").augroup
			local lualine = require("lualine")

			local lsp = {
				"lsp_status",
				icon = "", -- f013
				symbols = {
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					done = "✓",
					separator = " ",
				},
				ignore_lsp = {},
				show_name = true,
			}

			local function repo_name()
				local root = vim.fs.root(0, ".git") or vim.fs.root(vim.fn.getcwd(), ".git")
				return root and vim.fs.basename(root) or ""
			end

			local repository = {
				repo_name,
				icon = "󰊢",
			}

			local function has_window_splits()
				local normal_windows = 0

				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.api.nvim_win_get_config(win).relative == "" then
						normal_windows = normal_windows + 1
					end
				end

				return normal_windows > 1
			end

			local winbar_exclusions = {
				filetype_prefixes = {
					"snacks_",
				},
				buffer_names = {
					["kulala://ui"] = true,
				},
			}

			local function should_exclude_winbar()
				local filetype = vim.bo.filetype
				for _, prefix in ipairs(winbar_exclusions.filetype_prefixes) do
					if vim.startswith(filetype, prefix) then
						return true
					end
				end

				return winbar_exclusions.buffer_names[vim.api.nvim_buf_get_name(0)]
			end

			local function show_winbar()
				return has_window_splits() and not should_exclude_winbar()
			end

			local winbar_filename = {
				"filename",
				cond = show_winbar,
				color = "UserLualineWinbarActive",
				file_status = true,
				newfile_status = true,
				path = 1,
				shorting_target = 40,
				symbols = {
					modified = " ●",
					readonly = " ",
					unnamed = "[No Name]",
					newfile = " [New]",
				},
			}

			local inactive_winbar_filename = vim.tbl_extend("force", winbar_filename, {
				shorting_target = 20,
				color = "UserLualineWinbarInactive",
			})

			local winbar_spacer = {
				"%=",
				cond = show_winbar,
				color = "UserLualineWinbarActive",
				padding = 0,
			}

			local inactive_winbar_spacer = vim.tbl_extend("force", winbar_spacer, {
				color = "UserLualineWinbarInactive",
			})

			local winbar_diagnostics = {
				"diagnostics",
				cond = show_winbar,
				sections = { "error", "warn", "info", "hint" },
				symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
				colored = true,
				color = "UserLualineWinbarActive",
				update_in_insert = false,
			}

			local winbar_filetype = {
				"filetype",
				cond = show_winbar,
				icon_only = true,
				padding = { left = 1, right = 0 },
				color = "UserLualineWinbarActive",
			}

			local inactive_winbar_filetype = vim.tbl_extend("force", winbar_filetype, {
				color = "UserLualineWinbarInactive",
			})

			local function apply_winbar_highlights()
				local tab_active = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
				local tab_inactive = vim.api.nvim_get_hl(0, { name = "StatusLineNC", link = false })
				local active = vim.api.nvim_get_hl(0, { name = "lualine_c_normal", link = false })
				local inactive = vim.api.nvim_get_hl(0, { name = "lualine_b_inactive", link = false })
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

				if tab_active.bg then
					vim.api.nvim_set_hl(0, "UserLualineTabActive", {
						bg = tab_active.bg,
						fg = tab_active.fg,
						bold = true,
					})
				end

				if tab_inactive.bg then
					vim.api.nvim_set_hl(0, "UserLualineTabInactive", {
						bg = tab_inactive.bg,
						fg = tab_inactive.fg,
						bold = true,
					})
				end

				if active.fg and normal.bg then
					vim.api.nvim_set_hl(0, "WinBar", {
						bg = normal.bg,
						fg = active.fg,
						bold = active.bold,
					})
					vim.api.nvim_set_hl(0, "UserLualineWinbarActive", {
						bg = normal.bg,
						fg = active.fg,
						bold = active.bold,
					})
				end

				if inactive.fg and normal.bg then
					vim.api.nvim_set_hl(0, "WinBarNC", {
						bg = normal.bg,
						fg = inactive.fg,
						bold = inactive.bold,
					})
					vim.api.nvim_set_hl(0, "UserLualineWinbarInactive", {
						bg = normal.bg,
						fg = inactive.fg,
						bold = inactive.bold,
					})
					vim.api.nvim_set_hl(0, "lualine_c_inactive", {
						bg = normal.bg,
						fg = inactive.fg,
						bold = inactive.bold,
					})
					vim.api.nvim_set_hl(0, "lualine_x_inactive", {
						bg = normal.bg,
						fg = inactive.fg,
						bold = inactive.bold,
					})
				end
			end

			lualine.setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = false,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
						refresh_time = 16, -- ~60fps
						events = {
							"WinEnter",
							"BufEnter",
							"BufWritePost",
							"SessionLoadPost",
							"FileChangedShellPost",
							"VimResized",
							"Filetype",
							"WinClosed",
							"WinNew",
							"CursorMoved",
							"CursorMovedI",
							"ModeChanged",
						},
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { repository, "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
						lsp,
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					lualine_a = {
						{
							"tabs",
							section_separators = { left = "", right = "" },
							component_separators = { left = "", right = "" },
							max_length = function()
								return vim.o.columns
							end,
							tabs_color = {
								active = "UserLualineTabActive",
								inactive = "UserLualineTabInactive",
							},
							mode = 2,
						},
					},
				},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { winbar_filename, winbar_spacer, winbar_diagnostics, winbar_filetype },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { inactive_winbar_filename, inactive_winbar_spacer, inactive_winbar_filetype },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = {},
			})

			apply_winbar_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = augroup("lualine_winbar_highlights"),
				callback = function()
					vim.schedule(apply_winbar_highlights)
				end,
			})
		end,
	},
}
