local M = {}

function M.setup()
	if M._did_setup then
		return
	end

	vim.pack.add({
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
			version = "main",
		},
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
			version = "main",
		},
	})

	-- vim.pack installs nvim-treesitter under an opt directory, but the query files
	-- live under its nested runtime/ subtree. Add that subtree so highlight queries
	-- like queries/python/highlights.scm are visible on runtimepath.
	local treesitter_runtime = vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime"
	if not vim.tbl_contains(vim.opt.runtimepath:get(), treesitter_runtime) then
		vim.opt.runtimepath:append(treesitter_runtime)
	end

	require("nvim-treesitter").setup({})
	require("nvim-treesitter").install({
		"bash",
		"css",
		"c_sharp",
		"diff",
		"dockerfile",
		"gitcommit",
		"gitignore",
		"html",
		"ini",
		"javascript",
		"jsdoc",
		"json",
		"lua",
		"luadoc",
		"luap",
		"make",
		"markdown",
		"markdown_inline",
		"mermaid",
		"nginx",
		"python",
		"query",
		"regex",
		"scss",
		"sql",
		"terraform",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	})

	require("nvim-treesitter-textobjects").setup({
		select = {
			enable = true,
			lookahead = true,
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			include_surrounding_whitespace = false,
		},
		move = {
			enable = true,
			set_jumps = true,
		},
	})

	-- SELECT keymaps
	local sel = require("nvim-treesitter-textobjects.select")
	for _, map in ipairs({
		{ { "x", "o" }, "af", "@function.outer" },
		{ { "x", "o" }, "if", "@function.inner" },
		{ { "x", "o" }, "ac", "@class.outer" },
		{ { "x", "o" }, "ic", "@class.inner" },
		{ { "x", "o" }, "aa", "@parameter.outer" },
		{ { "x", "o" }, "ia", "@parameter.inner" },
		{ { "x", "o" }, "ad", "@comment.outer" },
		{ { "x", "o" }, "as", "@statement.outer" },
	}) do
		vim.keymap.set(map[1], map[2], function()
			sel.select_textobject(map[3], "textobjects")
		end, { desc = "Select " .. map[3] })
	end

	-- MOVE keymaps
	local mv = require("nvim-treesitter-textobjects.move")
	for _, map in ipairs({
		{ { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },
		{ { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" },
		{ { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },
		{ { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },
		{ { "n", "x", "o" }, "]M", mv.goto_next_end, "@function.outer" },
		{ { "n", "x", "o" }, "[M", mv.goto_previous_end, "@function.outer" },
		{ { "n", "x", "o" }, "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
		{ { "n", "x", "o" }, "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
	}) do
		local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
		-- build a human-readable desc
		local qstr = (type(query) == "table") and table.concat(query, ",") or query
		vim.keymap.set(modes, lhs, function()
			fn(query, "textobjects")
		end, { desc = "Move to " .. qstr })
	end

	vim.api.nvim_create_autocmd("PackChanged", {
		desc = "Handle nvim-treesitter updates",
		group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
		callback = function(event)
			if event.data.kind == "update" then
				local ok = pcall(vim.cmd, "TSUpdate")
				if ok then
					vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
				else
					vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
				end
			end
		end,
	})

	local SKIP_FT = {
		[""] = true,
		qf = true,
		help = true,
		man = true,
		notify = true,
		snacks_notif = true,
		snacks_notif_history = true,
		snacks_picker_list = true,
		snacks_picker_input = true,
		snacks_input = true,
		snacks_terminal = true,
		gitcommit = true,
		gitrebase = true,
		lspinfo = true,
		checkhealth = true,
		startuptime = true,
		TelescopePrompt = true,
		TelescopeResults = true,
		spectre_panel = true,
		["grug-far"] = true,
		trouble = true,
	}

	local function start_treesitter(buf)
		local ft = vim.bo[buf].filetype
		if SKIP_FT[ft] then
			return
		end

		local ok = pcall(vim.treesitter.start, buf)
		if not ok then
			return
		end

		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			vim.wo[win].foldmethod = "expr"
			vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "*" },
		callback = function(event)
			start_treesitter(event.buf)
		end,
	})

	vim.schedule(function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				start_treesitter(buf)
			end
		end
	end)

	vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

	M._did_setup = true
end

return M
