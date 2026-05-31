vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://gitlab.com/tduyng/vdiff.nvim",
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
	show_deleted = true,
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
		end, "Next Hunk")

		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, "Prev Hunk")

		map("n", "]H", function()
			gs.nav_hunk("last")
		end, "Last Hunk")
		map("n", "[H", function()
			gs.nav_hunk("first")
		end, "First Hunk")

		map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
		map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

		map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
		map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
		map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
		map("n", "<leader>ghb", function()
			gs.blame_line({ full = true })
		end, "Blame Line")
		map("n", "<leader>ghB", function()
			gs.blame()
		end, "Blame Buffer")
		map("n", "<leader>ght", gs.toggle_deleted, "Toggle Deleted")
		map("n", "<leader>ghd", gs.diffthis, "Diff This")
		map("n", "<leader>ghD", function()
			gs.diffthis("~")
		end, "Diff This ~")

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
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

-- Setup vdiff.nvim with side-by-side layout (IntelliJ style)
require("vdiff").setup({
	diff_layout = "diff2_vertical", -- side-by-side
	merge_layout = "diff3_vertical", -- 3-way side-by-side
})

-- Accepts any ref: branch, commit, tag, HEAD~N, or empty for working tree
-- Empty or nil = working tree vs HEAD
-- --staged = staged changes
-- main = compare with main branch
-- HEAD~3 = compare with 3 commits ago
-- abc123 = compare with commit hash
-- v1.0.0 = compare with tag
vim.keymap.set("n", "<leader>gc", function()
	vim.ui.input({
		prompt = "Compare with (branch/commit/tag/HEAD~N, empty=working): ",
	}, function(ref)
		local args = ref and ref:match("%S") and { ref } or {}
		vim.cmd({ cmd = "VDiffCompare", args = args })
	end)
end, { desc = "Compare Refs" })

-- COMPARE TWO REFS (e.g., branches, commits, tags)
vim.keymap.set("n", "<leader>gC", function()
	vim.ui.input({ prompt = "Compare ref1 (default=HEAD): " }, function(ref1)
		if not ref1 or ref1 == "" then
			ref1 = "HEAD"
		end
		vim.ui.input({ prompt = "Compare ref2: " }, function(ref2)
			local args = { ref1 }
			if ref2 and ref2:match("%S") then
				table.insert(args, ref2)
			end
			vim.cmd({ cmd = "VDiffCompareRefs", args = args })
		end)
	end)
end, { desc = "Compare Two Refs" })

-- Quick shortcuts for common comparisons
vim.keymap.set("n", "<leader>gd", "<Cmd>VDiffCompare<CR>", { desc = "Diff Working Tree" })
vim.keymap.set("n", "<leader>gD", "<Cmd>VDiffCompare --staged<CR>", { desc = "Diff Staged Changes" })
vim.keymap.set("n", "<leader>gV", "<Cmd>VDiffHistory<CR>", { desc = "Show File History" })
vim.keymap.set("v", "<leader>gv", ":'<,'>VDiffRange<CR>", { desc = "Show Line History" })
vim.keymap.set("n", "<leader>gx", "<Cmd>VDiffClose<CR>", { desc = "Close All Diffs" })
-- 3-way merge view (LOCAL | RESULT | REMOTE)
vim.keymap.set("n", "<leader>gm", "<Cmd>VMerge<CR>", { desc = "Resolve Merge Conflicts" })

-- CURRENT FILE DIFF
-- Same principle: accepts any ref or empty for HEAD
vim.keymap.set("n", "<leader>gf", "<Cmd>VDiff<CR>", { desc = "Diff File Against HEAD" })
vim.keymap.set("n", "<leader>gF", function()
	vim.ui.input({ prompt = "Diff file with (ref, empty=HEAD): " }, function(ref)
		local args = ref and ref:match("%S") and { ref } or {}
		vim.cmd({ cmd = "VDiff", args = args })
	end)
end, { desc = "Diff File Against Ref" })

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
end, { desc = "Compare Two Files" })
