local M = {}

function M.setup()
	if M._did_setup then
		return
	end

	vim.api.nvim_create_user_command("MapTable", function()
		local maps = vim.api.nvim_exec2("silent map", { output = true }).output
		local lines = vim.split(maps, "\n", { plain = true })
		local out = { "mode\tkey\trhs\tdescription" }

		local i = 1
		while i <= #lines do
			local line = lines[i]
			local desc = ""
			local nextline = lines[i + 1] or ""

			if nextline:match("^%s+") then
				desc = nextline:gsub("^%s+", "")
				i = i + 1
			end

			local mode, key, rhs = line:match("^([nvsxoictl! ]+)%s+(%S+)%s+%*?%s*(.*)$")
			if mode and key and rhs then
				table.insert(
					out,
					table.concat({
						vim.trim(mode),
						key,
						vim.trim(rhs),
						desc,
					}, "\t")
				)
			end

			i = i + 1
		end

		vim.cmd("new")
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "wipe"
		vim.bo.swapfile = false
		vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
	end, {})

	M._did_setup = true
end

return M
