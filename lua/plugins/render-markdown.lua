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

local function toggle_rendering()
	local rm = require("render-markdown")
	local enabled = require("render-markdown.state").enabled
	if enabled then
		rm.disable()
	else
		rm.enable()
	end
end

local function feed_keys(keys)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

return {
	{
		src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
		name = "render-markdown.nvim",
		keys = {
			{
				lhs = "<leader>mt",
				desc = "Markdown rendering toggle",
				callback = toggle_rendering,
			},
			{
				mode = "x",
				lhs = "<leader>mb",
				desc = "Bold selection",
				callback = function()
					feed_keys('c**<C-r>"**<Esc>')
				end,
			},
			{
				mode = "x",
				lhs = "<leader>mi",
				desc = "Italic selection",
				callback = function()
					feed_keys('c*<C-r>"*<Esc>')
				end,
			},
			{
				mode = "x",
				lhs = "<leader>mc",
				desc = "Code selection",
				callback = function()
					feed_keys('c`<C-r>"`<Esc>')
				end,
			},
			{
				mode = "x",
				lhs = "<leader>ml",
				desc = "Link selection",
				callback = function()
					feed_keys('c[<C-r>"]()<Esc>F(a')
				end,
			},
			{
				lhs = "<leader>m<",
				desc = "Increase heading level",
				callback = function()
					adjust_heading_level(-1)
				end,
			},
			{
				lhs = "<leader>m>",
				desc = "Decrease heading level",
				callback = function()
					adjust_heading_level(1)
				end,
			},
			{
				lhs = "<leader>mh",
				desc = "Insert horizontal rule",
				callback = insert_horizontal_rule,
			},
			{
				lhs = "<leader>mx",
				desc = "Checkbox toggle",
				callback = toggle_checkbox,
			},
		},
		config = function()
			require("render-markdown").setup(require("plugins.markdown.render_opts"))
		end,
	},
}
