return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		name = "nvim-treesitter-textobjects",
		version = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = false,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
			})

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
				local qstr = (type(query) == "table") and table.concat(query, ",") or query
				vim.keymap.set(modes, lhs, function()
					fn(query, "textobjects")
				end, { desc = "Move to " .. qstr })
			end
		end,
	},
}
