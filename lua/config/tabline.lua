vim.o.showtabline = 2

function _G.MyTabLine()
	local s = ""

	for tab = 1, vim.fn.tabpagenr("$") do
		local hl = (tab == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"

		local win = vim.fn.tabpagewinnr(tab)
		local bufs = vim.fn.tabpagebuflist(tab)
		local bufnr = bufs[win]
		local file = vim.fn.bufname(bufnr)
		local label = file ~= "" and vim.fn.fnamemodify(file, ":t") or "[No Name]"

		s = s .. hl .. " " .. tab .. " " .. label .. " "
	end

	s = s .. "%#TabLineFill#"
	return s
end

vim.o.tabline = "%!v:lua.MyTabLine()"
