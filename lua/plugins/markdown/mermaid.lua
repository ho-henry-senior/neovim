local M = {}

local function html_escape(value)
	return tostring(value):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")
end

local function fence_info(line)
	local ticks, tick_lang = line:match("^%s*(```+)%s*([%w_-]*)")
	if ticks then
		return "`", #ticks, tick_lang
	end

	local tildes, tilde_lang = line:match("^%s*(~~~+)%s*([%w_-]*)")
	if tildes then
		return "~", #tildes, tilde_lang
	end
end

local function is_closing_fence(line, char, min_len)
	local fence = line:match("^%s*([" .. char .. "]+)%s*$")
	return fence and #fence >= min_len
end

local function source_from_markdown()
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local start_line, fence_char, fence_len

	for line_number = cursor, 1, -1 do
		local char, len, lang = fence_info(lines[line_number] or "")
		if char and lang:lower() == "mermaid" then
			start_line = line_number
			fence_char = char
			fence_len = len
			break
		end
	end

	if not start_line then
		return nil, "No Mermaid code fence found above the cursor"
	end

	local end_line
	for line_number = start_line + 1, #lines do
		if is_closing_fence(lines[line_number] or "", fence_char, fence_len) then
			end_line = line_number
			break
		end
	end

	if not end_line or cursor >= end_line then
		return nil, "Cursor is not inside a complete Mermaid code fence"
	end

	return table.concat(vim.list_slice(lines, start_line + 1, end_line - 1), "\n")
end

local function source()
	if vim.bo.filetype == "mermaid" then
		return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	end

	return source_from_markdown()
end

local function local_mermaid_script()
	for _, path in ipairs(vim.api.nvim_get_runtime_file("app/_static/mermaid.min.js", false)) do
		if path:match("markdown%-preview%.nvim") then
			return vim.uri_from_fname(path)
		end
	end

	local pack_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/markdown-preview.nvim/app/_static/mermaid.min.js"
	if vim.uv.fs_stat(pack_path) then
		return vim.uri_from_fname(pack_path)
	end
end

local function preview_html(diagram, title)
	local script = local_mermaid_script()
	local script_tag
	if script then
		script_tag = string.format('<script src="%s"></script>', html_escape(script))
	else
		script_tag = '<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>'
	end

	return table.concat({
		"<!doctype html>",
		'<html lang="en">',
		"<head>",
		'<meta charset="utf-8">',
		'<meta name="viewport" content="width=device-width, initial-scale=1">',
		"<title>" .. html_escape(title) .. "</title>",
		script_tag,
		"<style>",
		"body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; color: #111827; }",
		".mermaid { max-width: 100%; overflow: auto; }",
		"</style>",
		"</head>",
		"<body>",
		'<pre class="mermaid"></pre>',
		"<script>",
		"document.querySelector('.mermaid').textContent = " .. vim.json.encode(diagram) .. ";",
		"mermaid.initialize({ startOnLoad: true, theme: 'default' });",
		"</script>",
		"</body>",
		"</html>",
	}, "\n")
end

function M.preview()
	local diagram, err = source()
	if not diagram or vim.trim(diagram) == "" then
		vim.notify(err or "No Mermaid source to preview", vim.log.levels.WARN)
		return
	end

	local cache_dir = vim.fn.stdpath("cache") .. "/mermaid-preview"
	vim.fn.mkdir(cache_dir, "p")

	local path = cache_dir .. "/index.html"
	local title = vim.fn.expand("%:t")
	if title == "" then
		title = "Mermaid Preview"
	end

	local lines = vim.split(preview_html(diagram, title), "\n", { plain = true })
	local ok, write_result = pcall(vim.fn.writefile, lines, path)
	if not ok or write_result ~= 0 then
		local write_err = ok and write_result or write_result
		vim.notify("Failed to write Mermaid preview: " .. tostring(write_err), vim.log.levels.ERROR)
		return
	end

	vim.ui.open(path)
end

return M
