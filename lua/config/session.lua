local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions/"

local function get_session_file()
	local cwd = vim.fn.getcwd()
	local session_name = cwd:gsub("/", "%%")
	return session_dir .. session_name .. ".vim"
end

local function get_last_session_file()
	return session_dir .. "last_session.vim"
end

local function get_stop_file()
	return session_dir .. ".stop_saving"
end

local function load_session(session_file)
	vim.cmd("source " .. vim.fn.fnameescape(session_file))
	vim.cmd("filetype detect")
	vim.cmd("doautocmd BufEnter")
	vim.api.nvim_exec_autocmds("SessionLoadPost", {})
end

function M.setup()
	if M._did_setup then
		return
	end

	vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos"

	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end

	-- Auto-restore session when starting with no arguments
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if vim.fn.argc() == 0 then
				local session_file = get_session_file()
				if vim.fn.filereadable(session_file) == 1 then
					vim.cmd("silent! set winminwidth=1 winwidth=1 winminheight=1 winheight=1")
					load_session(session_file)
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			local stop_file = get_stop_file()
			if vim.fn.filereadable(stop_file) == 1 then
				vim.fn.delete(stop_file)
				return
			end

			local buf_count = 0
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
					buf_count = buf_count + 1
				end
			end

			if buf_count >= 1 then
				local session_file = get_session_file()
				vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
				vim.cmd("mksession! " .. vim.fn.fnameescape(get_last_session_file()))
			end
		end,
	})

	vim.keymap.set("n", "<leader>Sc", function()
		local session_file = get_session_file()
		local deleted = false

		if vim.fn.filereadable(session_file) == 1 then
			vim.fn.delete(session_file)
			deleted = true
		end

		vim.fn.writefile({}, get_stop_file())

		if deleted then
			print("Cleared session for current directory")
		else
			print("No session found; next auto-save skipped")
		end
	end, { desc = "Clear project session" })

	M._did_setup = true
end

return M
