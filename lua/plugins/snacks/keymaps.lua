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
		"<leader>sg",
		function(Snacks)
			Snacks.picker.grep({ cwd = Snacks.git.get_root() or vim.fn.getcwd(0) })
		end,
		desc = "Search project",
	},
	{
		"<leader>sw",
		function(Snacks)
			Snacks.picker.grep_word()
		end,
		desc = "Search project for word or selection",
		mode = { "n", "x" },
	},
	{
		"<leader>ia",
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
		desc = "Search buffer",
	},
	{
		"<leader>ic",
		function(Snacks)
			Snacks.picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>ii",
		function(Snacks)
			Snacks.picker.icons()
		end,
		desc = "Icons",
	},
	{
		"<leader>ik",
		function(Snacks)
			Snacks.picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>uC",
		function(Snacks)
			Snacks.picker.colorschemes()
		end,
		desc = "Colorschemes",
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
