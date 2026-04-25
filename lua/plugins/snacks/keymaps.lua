local M = {}

-- Keep Snacks keymaps centralized so the plugin entrypoint stays small and the
-- large picker/navigation surface can evolve without mixing into setup logic.
local keymaps = {
	{
		"<leader><space>",
		function(Snacks)
			Snacks.picker.smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>n",
		function(Snacks)
			Snacks.picker.notifications()
		end,
		desc = "Notification History",
	},
	{
		"<leader>e",
		function(Snacks)
			Snacks.explorer()
		end,
		desc = "File Explorer",
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
		desc = "Find Config File",
	},
	{
		"<leader>ff",
		function(Snacks)
			Snacks.picker.files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>fg",
		function(Snacks)
			Snacks.picker.git_files()
		end,
		desc = "Find Git Files",
	},
	{
		"<leader>fp",
		function(Snacks)
			Snacks.picker.projects()
		end,
		desc = "Open Project",
	},
	{
		"<leader>fr",
		function(Snacks)
			Snacks.picker.recent()
		end,
		desc = "Recent Files",
	},
	{
		"<leader>gb",
		function(Snacks)
			Snacks.picker.git_branches()
		end,
		desc = "Git Branches",
	},
	{
		"<leader>gl",
		function(Snacks)
			Snacks.picker.git_log()
		end,
		desc = "Git Log",
	},
	{
		"<leader>gL",
		function(Snacks)
			Snacks.picker.git_log_line()
		end,
		desc = "Git Log Line",
	},
	{
		"<leader>gs",
		function(Snacks)
			Snacks.picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>gS",
		function(Snacks)
			Snacks.picker.git_stash()
		end,
		desc = "Git Stash",
	},
	{
		"<leader>gp",
		function(Snacks)
			Snacks.picker.git_diff()
		end,
		desc = "Git Diff Picker (Hunks)",
	},
	{
		"<leader>gP",
		function(Snacks)
			Snacks.picker.git_diff({ base = "origin" })
		end,
		desc = "Git Diff Picker (origin)",
	},
	{
		"<leader>gH",
		function(Snacks)
			Snacks.picker.git_log_file()
		end,
		desc = "Git Log File",
	},
	{
		"<leader>gB",
		function(Snacks)
			Snacks.gitbrowse()
		end,
		desc = "Open in Remote",
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
		desc = "Grep Open Buffers",
	},
	{
		"<leader>sg",
		function(Snacks)
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>sw",
		function(Snacks)
			Snacks.picker.grep_word()
		end,
		desc = "Grep Selection or Word",
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
		desc = "Search History",
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
		desc = "Buffer Lines",
	},
	{
		"<leader>sc",
		function(Snacks)
			Snacks.picker.command_history()
		end,
		desc = "Command History",
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
		desc = "Buffer Diagnostics",
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
		desc = "Location List",
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
		desc = "Man Pages",
	},
	{
		"<leader>sp",
		function(Snacks)
			Snacks.picker.lazy()
		end,
		desc = "Search Plugin Specs",
	},
	{
		"<leader>sq",
		function(Snacks)
			Snacks.picker.qflist()
		end,
		desc = "Quickfix List",
	},
	{
		"<leader>sR",
		function(Snacks)
			Snacks.picker.resume()
		end,
		desc = "Resume Picker",
	},
	{
		"<leader>su",
		function(Snacks)
			Snacks.picker.undo()
		end,
		desc = "Undo History",
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
		desc = "LSP Symbols",
	},
	{
		"<leader>sS",
		function(Snacks)
			Snacks.picker.lsp_workspace_symbols()
		end,
		desc = "LSP Workspace Symbols",
	},
	{
		"gai",
		function(Snacks)
			Snacks.picker.lsp_incoming_calls()
		end,
		desc = "C[a]lls Incoming",
		has = "callHierarchy/incomingCalls",
	},
	{
		"gao",
		function(Snacks)
			Snacks.picker.lsp_outgoing_calls()
		end,
		desc = "C[a]lls Outgoing",
		has = "callHierarchy/outgoingCalls",
	},
	{
		"<leader>bd",
		function(Snacks)
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer",
		mode = { "n" },
	},
	{
		"<leader>bo",
		function(Snacks)
			Snacks.bufdelete.other()
		end,
		desc = "Delete Other Buffers",
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
		"<leader>z",
		function(Snacks)
			Snacks.zen.zoom()
		end,
		desc = "Toggle Zoom",
	},
	{
		"<leader>cR",
		function(Snacks)
			Snacks.rename.rename_file()
		end,
		desc = "Rename File",
	},
	{
		"<leader>un",
		function(Snacks)
			Snacks.notifier.hide()
		end,
		desc = "Dismiss All Notifications",
	},
	{
		"]r",
		function(Snacks)
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n" },
	},
	{
		"[r",
		function(Snacks)
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
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
