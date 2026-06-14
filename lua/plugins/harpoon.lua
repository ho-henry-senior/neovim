return {
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		name = "harpoon",
		version = "harpoon2",
		dependencies = {
			{
				src = "https://github.com/nvim-lua/plenary.nvim",
				name = "plenary.nvim",
			},
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = {
					save_on_toggle = true,
				},
			})

			local function map(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { desc = desc })
			end

			local function navigate(direction)
				local list = harpoon:list()
				if list:length() == 0 then
					return
				end

				list[direction](list)
			end

			map("<leader>h", function()
				harpoon:list():add()
			end, "Harpoon add file")

			map("<leader>H", function()
				harpoon:list():remove()
			end, "Harpoon remove file")

			map("<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, "Harpoon menu")

			map("<S-h>", function()
				navigate("prev")
			end, "Harpoon previous file")

			map("<S-l>", function()
				navigate("next")
			end, "Harpoon next file")

			for i = 1, 4 do
				map("<leader>" .. i, function()
					harpoon:list():select(i)
				end, "which_key_ignore")
			end

			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open vertical split" })

					vim.keymap.set("n", "<C-s>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open split" })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open tab" })
				end,
			})
		end,
	},
}
