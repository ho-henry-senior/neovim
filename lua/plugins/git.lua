vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
})

-- Setup gitsigns.nvim
require("gitsigns").setup({
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

		map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
		map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")

		map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
		map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
		map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
		map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
		map("n", "<leader>ghb", function()
			gs.blame_line({ full = true })
		end, "Blame line")
		map("n", "<leader>ghB", function()
			gs.blame()
		end, "Blame buffer")
		map("n", "<leader>ght", gs.toggle_deleted, "Deleted toggle")
		map("n", "<leader>ghd", gs.diffthis, "Diff this")
		map("n", "<leader>ghD", function()
			gs.diffthis("~")
		end, "Diff this ~")

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
	end,
})

-- Attach gitsigns to any buffers already open when the session is restored
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

-- UTILITY: Compare two arbitrary files (not git-related)
vim.keymap.set("n", "<leader>g2", function()
	vim.ui.input({ prompt = "First file: " }, function(file1)
		if not file1 or not file1:match("%S") then
			return
		end
		vim.ui.input({ prompt = "Second file: " }, function(file2)
			if file2 and file2:match("%S") then
				vim.cmd.tabnew()
				vim.cmd.edit(vim.fn.fnameescape(file1))
				vim.cmd.diffthis()
				vim.cmd.vsplit(vim.fn.fnameescape(file2))
				vim.cmd.diffthis()
			end
		end)
	end)
end, { desc = "Compare two files" })
