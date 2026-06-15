vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos"

-- Create sessions directory if it doesn't exist
local session_dir = vim.fn.stdpath("state") .. "/sessions/"
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

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

local function detect_loaded_filetypes()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].filetype == "" then
			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" then
				pcall(vim.api.nvim_buf_call, buf, function()
					vim.cmd("filetype detect")
				end)
			end
		end
	end
end

local function load_session(session_file)
	vim.cmd("source " .. vim.fn.fnameescape(session_file))
	detect_loaded_filetypes()
	vim.cmd("doautocmd BufEnter")
	vim.api.nvim_exec_autocmds("SessionLoadPost", {})
end

local function restore_project_session()
	if vim.fn.argc() ~= 0 then
		return
	end

	local session_file = get_session_file()
	if vim.fn.filereadable(session_file) == 0 then
		return
	end

	vim.cmd("silent! set winminwidth=1 winwidth=1 winminheight=1 winheight=1")
	load_session(session_file)
end

local function has_file_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
			return true
		end
	end

	return false
end

local function save_project_session()
	local stop_file = get_stop_file()
	if vim.fn.filereadable(stop_file) == 1 then
		vim.fn.delete(stop_file)
		return
	end

	if not has_file_buffers() then
		return
	end

	vim.cmd("mksession! " .. vim.fn.fnameescape(get_session_file()))
	vim.cmd("mksession! " .. vim.fn.fnameescape(get_last_session_file()))
end

local function clear_project_session()
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
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = restore_project_session,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = save_project_session,
})

-- Clear the saved session for the current project and skip the next auto-save
vim.keymap.set("n", "<leader>Sc", clear_project_session, { desc = "Clear project session" })
