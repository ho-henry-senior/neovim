local M = {}

local function ensure_hunk()
	if vim.fn.executable("hunk") == 1 then
		return true
	end

	vim.notify(
		"hunk CLI not found. Install with `brew install modem-dev/tap/hunk` or `npm i -g hunkdiff`.",
		vim.log.levels.ERROR
	)
	return false
end

local function open(args)
	if not ensure_hunk() then
		return
	end

	local cwd = vim.fs.root(0, ".git") or vim.fn.getcwd()

	vim.cmd.tabnew()
	vim.fn.jobstart(vim.list_extend({ "hunk" }, args), {
		cwd = cwd,
		term = true,
		on_exit = function(_, code)
			if code ~= 0 then
				vim.schedule(function()
					vim.notify(("hunk exited with code %d"):format(code), vim.log.levels.WARN)
				end)
			end
		end,
	})
	vim.cmd.startinsert()
end

function M.diff(args)
	open(vim.list_extend({ "diff" }, args or {}))
end

function M.show(args)
	open(vim.list_extend({ "show" }, args or {}))
end

function M.setup()
	vim.api.nvim_create_user_command("HunkDiff", function(opts)
		M.diff(opts.fargs)
	end, {
		desc = "Open Hunk review UI for the working tree diff",
		nargs = "*",
		complete = "file",
	})

	vim.api.nvim_create_user_command("HunkShow", function(opts)
		M.show(opts.fargs)
	end, {
		desc = "Open Hunk review UI for a commit",
		nargs = "*",
		complete = "file",
	})
end

return M
