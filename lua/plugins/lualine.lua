vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

local lualine = require("lualine")

local lsp = {
	"lsp_status",
	icon = "", -- f013
	symbols = {
		-- Standard unicode symbols to cycle through for LSP progress:
		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
		-- Standard unicode symbol for when LSP is done:
		done = "✓",
		-- Delimiter inserted between LSP names:
		separator = " ",
	},
	-- List of LSP names to ignore (e.g., `null-ls`):
	ignore_lsp = {},
	-- Display the LSP name
	show_name = true,
}

local function has_window_splits()
	local normal_windows = 0

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			normal_windows = normal_windows + 1
		end
	end

	return normal_windows > 1
end

local function show_winbar()
	return has_window_splits() and vim.api.nvim_buf_get_name(0) ~= "kulala://ui"
end

local winbar_filename = {
	"filename",
	cond = show_winbar,
	file_status = true,
	newfile_status = true,
	path = 1,
	shorting_target = 40,
	symbols = {
		modified = " ●",
		readonly = " ",
		unnamed = "[No Name]",
		newfile = " [New]",
	},
}

local inactive_winbar_filename = vim.tbl_extend("force", winbar_filename, {
	shorting_target = 20,
	color = "StatusLineNC",
})

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "│", right = "│" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = false,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"WinClosed",
				"WinNew",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = {
			"encoding",
			"fileformat",
			"filetype",
			lsp,
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			{
				"tabs",
				tabs_color = {
					active = "StatusLine",
					inactive = "StatusLineNC",
				},
				mode = 2, -- show tab names
			},
		},
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { winbar_filename },
		lualine_x = {
			{
				"diagnostics",
				cond = show_winbar,
				sections = { "error", "warn", "info", "hint" },
				symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
				colored = true,
				update_in_insert = false,
			},
			{
				"filetype",
				cond = show_winbar,
				icon_only = true,
				padding = { left = 1, right = 0 },
			},
		},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { inactive_winbar_filename },
		lualine_x = {
			{
				"filetype",
				cond = show_winbar,
				icon_only = true,
				padding = { left = 1, right = 0 },
				color = "StatusLineNC",
			},
		},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
})

local lualine_winbar = lualine.winbar

lualine.winbar = function(...)
	if vim.api.nvim_buf_get_name(0) == "kulala://ui" then
		return vim.wo.winbar
	end

	return lualine_winbar(...)
end
