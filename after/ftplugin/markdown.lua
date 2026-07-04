vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_gb,en"

local function is_escaped(line, index)
	local count = 0
	index = index - 1
	while index >= 1 and line:sub(index, index) == "\\" do
		count = count + 1
		index = index - 1
	end
	return count % 2 == 1
end

local function find_closing(line, open_index, open_char, close_char)
	local depth = 1
	local index = open_index + 1

	while index <= #line do
		local char = line:sub(index, index)
		if char == close_char and not is_escaped(line, index) then
			depth = depth - 1
			if depth == 0 then
				return index
			end
		elseif char == open_char and not is_escaped(line, index) then
			depth = depth + 1
		end
		index = index + 1
	end
end

local function markdown_link_under_cursor()
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	local search_from = 1

	while search_from <= #line do
		local open_bracket = line:find("%[", search_from)
		if not open_bracket then
			return nil
		end

		local close_bracket = find_closing(line, open_bracket, "[", "]")
		if close_bracket and line:sub(close_bracket + 1, close_bracket + 1) == "(" then
			local open_paren = close_bracket + 1
			local close_paren = find_closing(line, open_paren, "(", ")")
			if close_paren then
				if cursor_col >= open_bracket and cursor_col <= close_paren then
					local target = vim.trim(line:sub(open_paren + 1, close_paren - 1))
					return target ~= "" and target or nil
				end
				search_from = close_paren + 1
			else
				search_from = close_bracket + 1
			end
		else
			search_from = open_bracket + 1
		end
	end
end

local function split_markdown_target(target)
	if target:sub(1, 1) == "<" then
		local close_angle = target:find(">", 2, true)
		if close_angle then
			target = vim.trim(target:sub(2, close_angle - 1))
		end
	elseif target:sub(1, 1) ~= "<" then
		target = target:match("^%S+") or target
	end

	local fragment_start = target:find("#", 1, true)
	if not fragment_start then
		return target, nil
	end

	return target:sub(1, fragment_start - 1), target:sub(fragment_start + 1)
end

local function decode_uri_path(path)
	return (path:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

local function decode_uri_fragment(fragment)
	if not fragment then
		return nil
	end

	fragment = fragment:gsub("+", " ")
	return (fragment:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

local function normalize_markdown_heading(text)
	text = text:lower()
	text = text:gsub("`([^`]*)`", "%1")
	text = text:gsub("<[^>]+>", "")
	text = text:gsub("[^%w%s%-_]", "")
	text = vim.trim(text)
	text = text:gsub("%s+", "-")
	text = text:gsub("%-+", "-")
	return text
end

local function find_heading(fragment)
	local wanted = normalize_markdown_heading(decode_uri_fragment(fragment))
	for line_number = 1, vim.api.nvim_buf_line_count(0) do
		local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
		local heading = line and line:match("^%s*#+%s+(.+)%s*$")
		if heading then
			heading = heading:gsub("%s+#+%s*$", "")
			if normalize_markdown_heading(heading) == wanted then
				return line_number
			end
		end
	end
end

local function resolve_markdown_path(path, base_dir)
	if path == "" then
		return vim.api.nvim_buf_get_name(0)
	end

	path = vim.fn.expand(decode_uri_path(path))
	if not path:match("^/") then
		path = base_dir .. "/" .. path
	end

	path = vim.fn.fnamemodify(path, ":p")
	if vim.uv.fs_stat(path) then
		return path
	end

	if vim.fn.fnamemodify(path, ":e") == "" then
		local markdown_path = path .. ".md"
		if vim.uv.fs_stat(markdown_path) then
			return markdown_path
		end
	end

	return path
end

local function follow_markdown_link()
	local target = markdown_link_under_cursor()
	if not target then
		vim.cmd("normal! gf")
		return
	end

	if target:match("^%a[%w+.-]*:") or target:match("^//") then
		vim.notify("gf only follows local Markdown links", vim.log.levels.INFO)
		return
	end

	local path, fragment = split_markdown_target(target)
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir = vim.fn.fnamemodify(current_file, ":h")
	local resolved_path = resolve_markdown_path(path, current_dir)
	local current_path = vim.fn.fnamemodify(current_file, ":p")

	if resolved_path ~= current_path then
		vim.cmd.edit(vim.fn.fnameescape(resolved_path))
	end

	if fragment and fragment ~= "" then
		local line_number = find_heading(fragment)
		if line_number then
			vim.api.nvim_win_set_cursor(0, { line_number, 0 })
			vim.cmd("normal! zv")
		else
			vim.notify("Markdown heading not found: #" .. fragment, vim.log.levels.WARN)
		end
	end
end

vim.keymap.set("n", "gf", follow_markdown_link, {
	buffer = true,
	desc = "Follow Markdown link",
})
