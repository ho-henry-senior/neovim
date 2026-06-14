return {
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		name = "gitsigns.nvim",
		module = "gitsigns",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			word_diff = true,
			numhl = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 800,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary> (<abbrev_sha>)",
			on_attach = function(buffer)
				local gs = require("gitsigns")

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
				end

				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next hunk")

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev hunk")

				map("n", "]H", function()
					gs.nav_hunk("last")
				end, "Last hunk")
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, "First hunk")

				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
			end,
		},
		config = function(spec, opts)
			require(spec.module).setup(opts)

			vim.api.nvim_create_autocmd("VimEnter", {
				once = true,
				callback = function()
					vim.schedule(function()
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf) then
								require("gitsigns").attach(buf)
							end
						end
					end)
				end,
			})
		end,
	},
}
