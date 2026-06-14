return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		name = "nvim-treesitter-textobjects",
		version = "main",
		module = "nvim-treesitter-textobjects",
		opts = {
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
		},
		keys = {
			{
				mode = { "x", "o" },
				lhs = "af",
				desc = "Select @function.outer",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "if",
				desc = "Select @function.inner",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "ac",
				desc = "Select @class.outer",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "ic",
				desc = "Select @class.inner",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "aa",
				desc = "Select @parameter.outer",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "ia",
				desc = "Select @parameter.inner",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "ad",
				desc = "Select @comment.outer",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				lhs = "as",
				desc = "Select @statement.outer",
				callback = function()
					require("nvim-treesitter-textobjects.select").select_textobject("@statement.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "]m",
				desc = "Move to @function.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "[m",
				desc = "Move to @function.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "]]",
				desc = "Move to @class.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "[[",
				desc = "Move to @class.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "]M",
				desc = "Move to @function.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "[M",
				desc = "Move to @function.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "]o",
				desc = "Move to @loop.inner,@loop.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
				end,
			},
			{
				mode = { "n", "x", "o" },
				lhs = "[o",
				desc = "Move to @loop.inner,@loop.outer",
				callback = function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						{ "@loop.inner", "@loop.outer" },
						"textobjects"
					)
				end,
			},
		},
	},
}
