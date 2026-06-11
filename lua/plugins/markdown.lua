local M = {}

local function toggle_checkbox()
	local line = vim.api.nvim_get_current_line()
	local updated, count = line:gsub("^(%s*[-*] )%[ %] ", "%1[x] ", 1)
	if count == 0 then
		updated, count = line:gsub("^(%s*[-*] )%[x%] ", "%1[ ] ", 1)
	end
	if count == 0 then
		updated, count = line:gsub("^(%s*[-*] )", "%1[ ] ", 1)
	end
	if count == 0 then
		return
	end

	vim.api.nvim_set_current_line(updated)
end

local function insert_horizontal_rule()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
	local current = lines[1] or ""
	local to_insert = {}

	if current ~= "" then
		table.insert(to_insert, "")
	end

	table.insert(to_insert, "---")
	table.insert(to_insert, "")

	vim.api.nvim_buf_set_lines(0, row, row, false, to_insert)
	vim.api.nvim_win_set_cursor(0, { row + #to_insert - 1, 0 })
end

local function adjust_heading_level(delta)
	local line = vim.api.nvim_get_current_line()
	local hashes, text = line:match("^(#+)%s+(.*)$")
	if not hashes then
		return
	end

	local level = #hashes + delta
	if level <= 0 then
		vim.api.nvim_set_current_line(text)
		return
	end

	vim.api.nvim_set_current_line(string.rep("#", level) .. " " .. text)
end

function M.setup()
	if M._did_setup then
		return
	end

	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_filetypes = { "markdown" }
	vim.g.mkdp_preview_options = vim.tbl_deep_extend("force", vim.g.mkdp_preview_options or {}, {
		maid = {},
	})

	vim.pack.add({
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
		"https://github.com/iamcco/markdown-preview.nvim",
	})

	require("render-markdown").setup(require("plugins.markdown.render_opts"))

	vim.keymap.set("n", "<leader>mt", function()
		local rm = require("render-markdown")
		local enabled = require("render-markdown.state").enabled
		if enabled then
			rm.disable()
		else
			rm.enable()
		end
	end, { desc = "Markdown rendering toggle" })

	vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview toggle" })

	vim.keymap.set("x", "<leader>mb", 'c**<C-r>"**<Esc>', { desc = "Bold selection", silent = true })
	vim.keymap.set("x", "<leader>mi", 'c*<C-r>"*<Esc>', { desc = "Italic selection", silent = true })
	vim.keymap.set("x", "<leader>mc", 'c`<C-r>"`<Esc>', { desc = "Code selection", silent = true })
	vim.keymap.set("x", "<leader>ml", 'c[<C-r>"]()<Esc>F(a', { desc = "Link selection", silent = true })

	vim.keymap.set("n", "<leader>m<", function()
		adjust_heading_level(-1)
	end, { desc = "Increase heading level" })

	vim.keymap.set("n", "<leader>m>", function()
		adjust_heading_level(1)
	end, { desc = "Decrease heading level" })

	vim.keymap.set("n", "<leader>mh", insert_horizontal_rule, { desc = "Insert horizontal rule" })
	vim.keymap.set("n", "<leader>mx", toggle_checkbox, { desc = "Checkbox toggle" })

	M._did_setup = true
end

return M
