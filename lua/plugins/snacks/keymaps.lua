local M = {}

-- Keep Snacks keymaps centralized so the plugin entrypoint stays small and the
-- large picker/navigation surface can evolve without mixing into setup logic.
local keymaps = {
	{
		"<leader><space>",
		function(Snacks)
			Snacks.picker.smart()
		end,
		desc = "Smart find files",
	},
	{
		"<leader>n",
		function(Snacks)
			Snacks.picker.notifications()
		end,
		desc = "Notification history",
	},
	{
		"<leader>e",
		function(Snacks)
			Snacks.explorer()
		end,
		desc = "File explorer",
	},
	{
		"<leader>bb",
		function(Snacks)
			Snacks.picker.buffers({
				win = {
					input = {
						keys = {
							["dd"] = "bufdelete",
							["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
						},
					},
					list = { keys = { ["dd"] = "bufdelete" } },
				},
			})
		end,
		desc = "Buffers",
	},
	{
		"<leader>fc",
		function(Snacks)
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Find config file",
	},
	{
		"<leader>ff",
		function(Snacks)
			Snacks.picker.files()
		end,
		desc = "Find files",
	},
	{
		"<leader>fg",
		function(Snacks)
			Snacks.picker.git_files()
		end,
		desc = "Find git files",
	},
	{
		"<leader>fp",
		function(Snacks)
			Snacks.picker.projects()
		end,
		desc = "Open project",
	},
	{
		"<leader>fr",
		function(Snacks)
			Snacks.picker.recent()
		end,
		desc = "Recent files",
	},
	{
		"<leader>gb",
		function(Snacks)
			Snacks.picker.git_branches()
		end,
		desc = "Git branches",
	},
	{
		"<leader>gl",
		function(Snacks)
			Snacks.picker.git_log()
		end,
		desc = "Git log",
	},
	{
		"<leader>gL",
		function(Snacks)
			Snacks.picker.git_log_line()
		end,
		desc = "Git log line",
	},
	{
		"<leader>gs",
		function(Snacks)
			Snacks.picker.git_status()
		end,
		desc = "Git status",
	},
	{
		"<leader>gS",
		function(Snacks)
			Snacks.picker.git_stash()
		end,
		desc = "Git stash",
	},
	{
		"<leader>gp",
		function(Snacks)
			Snacks.picker.git_diff()
		end,
		desc = "Git diff picker (hunks)",
	},
	{
		"<leader>gf",
		function(Snacks)
			Snacks.picker.git_log_file()
		end,
		desc = "Git log file",
	},
	{
		"<leader>gr",
		function(Snacks)
			Snacks.gitbrowse()
		end,
		desc = "Open in remote",
		mode = { "n", "v" },
	},
	{
		"<leader>gg",
		function(Snacks)
			Snacks.lazygit()
		end,
		desc = "Open Lazygit",
	},
	{
		"<leader>sB",
		function(Snacks)
			Snacks.picker.grep_buffers()
		end,
		desc = "Grep open buffers",
	},
	{
		"<leader>sg",
		function(Snacks)
			Snacks.picker.grep({ cwd = Snacks.git.get_root() or vim.fn.getcwd(0) })
		end,
		desc = "Grep",
	},
	{
		"<leader>sw",
		function(Snacks)
			Snacks.picker.grep_word()
		end,
		desc = "Grep selection or word",
		mode = { "n", "x" },
	},
	{
		'<leader>s"',
		function(Snacks)
			Snacks.picker.registers()
		end,
		desc = "Registers",
	},
	{
		"<leader>s/",
		function(Snacks)
			Snacks.picker.search_history()
		end,
		desc = "Search history",
	},
	{
		"<leader>sa",
		function(Snacks)
			Snacks.picker.autocmds()
		end,
		desc = "Autocmds",
	},
	{
		"<leader>sb",
		function(Snacks)
			Snacks.picker.lines()
		end,
		desc = "Buffer lines",
	},
	{
		"<leader>sc",
		function(Snacks)
			Snacks.picker.command_history()
		end,
		desc = "Command history",
	},
	{
		"<leader>sC",
		function(Snacks)
			Snacks.picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>sd",
		function(Snacks)
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>sD",
		function(Snacks)
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Buffer diagnostics",
	},
	{
		"<leader>sH",
		function(Snacks)
			Snacks.picker.highlights()
		end,
		desc = "Highlights",
	},
	{
		"<leader>si",
		function(Snacks)
			Snacks.picker.icons()
		end,
		desc = "Icons",
	},
	{
		"<leader>sj",
		function(Snacks)
			Snacks.picker.jumps()
		end,
		desc = "Jumps",
	},
	{
		"<leader>sk",
		function(Snacks)
			Snacks.picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>sl",
		function(Snacks)
			Snacks.picker.loclist()
		end,
		desc = "Location list",
	},
	{
		"<leader>sm",
		function(Snacks)
			Snacks.picker.marks()
		end,
		desc = "Marks",
	},
	{
		"<leader>sM",
		function(Snacks)
			Snacks.picker.man()
		end,
		desc = "Man pages",
	},
	{
		"<leader>sq",
		function(Snacks)
			Snacks.picker.qflist()
		end,
		desc = "Quickfix list",
	},
	{
		"<leader>sR",
		function(Snacks)
			Snacks.picker.resume()
		end,
		desc = "Resume picker",
	},
	{
		"<leader>su",
		function(Snacks)
			Snacks.picker.undo()
		end,
		desc = "Undo history",
	},
	{
		"<leader>uC",
		function(Snacks)
			Snacks.picker.colorschemes()
		end,
		desc = "Colorschemes",
	},
	{
		"<leader>ss",
		function(Snacks)
			Snacks.picker.lsp_symbols()
		end,
		desc = "LSP symbols",
	},
	{
		"<leader>sS",
		function(Snacks)
			Snacks.picker.lsp_workspace_symbols()
		end,
		desc = "LSP workspace symbols",
	},
	{
		"gai",
		function(Snacks)
			Snacks.picker.lsp_incoming_calls()
		end,
		desc = "C[a]lls incoming",
		has = "callHierarchy/incomingCalls",
	},
	{
		"gao",
		function(Snacks)
			Snacks.picker.lsp_outgoing_calls()
		end,
		desc = "C[a]lls outgoing",
		has = "callHierarchy/outgoingCalls",
	},
	{
		"<leader>bd",
		function(Snacks)
			Snacks.bufdelete()
		end,
		desc = "Delete buffer",
		mode = { "n" },
	},
	{
		"<leader>bo",
		function(Snacks)
			Snacks.bufdelete.other()
		end,
		desc = "Delete other buffers",
		mode = { "n" },
	},
	{
		"<c-_>",
		function(Snacks)
			Snacks.terminal()
		end,
		desc = "which_key_ignore",
	},
	{
		"<leader>cr",
		function(Snacks)
			Snacks.rename.rename_file()
		end,
		desc = "Rename file",
	},
	{
		"]r",
		function(Snacks)
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next reference",
		mode = { "n" },
	},
	{
		"[r",
		function(Snacks)
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev reference",
		mode = { "n" },
	},
}

function M.setup(Snacks)
	for _, keymap in ipairs(keymaps) do
		local opts = {
			desc = keymap.desc,
			noremap = keymap.noremap == nil and true or keymap.noremap,
		}
		if keymap.silent ~= nil then
			opts.silent = keymap.silent
		end
		if keymap.expr ~= nil then
			opts.expr = keymap.expr
		end

		local mode = keymap.mode or "n"
		vim.keymap.set(mode, keymap[1], function()
			keymap[2](Snacks)
		end, opts)
	end
end

return M
