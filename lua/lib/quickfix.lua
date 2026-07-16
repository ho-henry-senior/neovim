local M = {}

function M.set_items(title, items, opts)
	opts = opts or {}
	items = items or {}

	if #items == 0 then
		vim.notify(opts.empty_message or "No quickfix results", vim.log.levels.INFO)
		return false
	end

	vim.fn.setqflist({}, "r", {
		title = title,
		items = items,
	})

	if opts.open ~= false then
		vim.cmd("copen")
	end

	return true
end

return M
