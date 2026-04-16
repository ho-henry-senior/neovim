local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Autocmds are kept for editor lifecycle, buffer ergonomics, and a small number
-- of explicit filetype adjustments. Avoid adding plugin-specific workflow here
-- unless it genuinely needs event-driven behavior.

-- Auto-reload externally modified files (debounced checktime)
local _checktime_timer = nil
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if _checktime_timer then
			_checktime_timer:stop()
			_checktime_timer:close()
			_checktime_timer = nil
		end
		_checktime_timer = vim.defer_fn(function()
			_checktime_timer = nil
			if vim.o.buftype ~= "nofile" then
				vim.cmd("checktime")
			end
		end, 200) -- 200ms debounce
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- Keep splits equal on resize
local _resize_timer = nil
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		if _resize_timer then
			_resize_timer:stop()
			_resize_timer:close()
			_resize_timer = nil
		end
		local current_tab = vim.fn.tabpagenr()
		_resize_timer = vim.defer_fn(function()
			_resize_timer = nil
			vim.cmd("tabdo wincmd =")
			vim.cmd("tabnext " .. current_tab)
		end, 100)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Treat kebab-case (foo-bar) as a single word for CSS/HTML-like filetypes.
-- Keep this grouped until those filetypes need distinct local behavior.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("iskeyword_kebab"),
	pattern = { "css", "scss", "less", "html", "htmldjango", "blade", "typescriptreact", "javascriptreact" },
	callback = function()
		vim.opt_local.iskeyword:append("-")
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("man_unlisted"),
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", function()
			vim.cmd("close")
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end, {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer",
		})
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Let the explicit vim.filetype.add rules in options.lua handle .env files.

-- Set filetype for TOML-like config files not covered by Neovim defaults
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("toml_filetype"),
	pattern = { "*.tomg-config*" },
	callback = function()
		vim.opt_local.filetype = "toml"
	end,
})

-- Set filetype for .ejs files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("ejs_filetype"),
	pattern = { "*.ejs", "*.ejs.t" },
	callback = function()
		vim.opt_local.filetype = "embedded_template"
	end,
})
