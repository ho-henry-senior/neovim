return {
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		name = "gitsigns.nvim",
		-- Not actually lazy: gitsigns.nvim ships its own plugin/gitsigns.lua that
		-- calls require('gitsigns').setup() unconditionally as soon as Neovim's
		-- startup sourcing reaches it, regardless of this event trigger. Loading
		-- it eagerly here just means our real opts (and on_attach keymaps) take
		-- effect from that same moment instead of never overriding the defaults.
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
					vim.keymap.set(mode, lhs, rhs, { buf = buffer, desc = desc })
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

				map("n", "<leader>qh", function()
					gs.setqflist(0)
				end, "Hunks → quickfix (buffer)")
				map("n", "<leader>qH", function()
					gs.setqflist("attached")
				end, "Hunks → quickfix (all buffers)")
			end,
		},
		config = function(spec, opts)
			require(spec.module).setup(opts)

			local function attach_loaded_buffers()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) then
						require("gitsigns").attach(buf)
					end
				end
			end

			-- Covers buffers already open when this loads (e.g. a CLI file arg).
			vim.schedule(attach_loaded_buffers)

			-- Session-restored buffers never fire BufReadPre/BufRead/BufNewFile
			-- (Neovim's SessionLoad fast path skips them for performance), so
			-- gitsigns' own attach-on-BufRead autocmds never see them. Re-attach
			-- explicitly once session.lua's SessionLoadPost fires.
			vim.api.nvim_create_autocmd("SessionLoadPost", {
				callback = attach_loaded_buffers,
			})
		end,
	},
}
