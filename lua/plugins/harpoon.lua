local function harpoon()
	return require("harpoon")
end

local function navigate(direction)
	local list = harpoon():list()
	if list:length() == 0 then
		return
	end

	list[direction](list)
end

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
		keys = {
			{
				lhs = "<leader>h",
				desc = "Harpoon add file",
				callback = function()
					harpoon():list():add()
				end,
			},
			{
				lhs = "<leader>H",
				desc = "Harpoon remove file",
				callback = function()
					harpoon():list():remove()
				end,
			},
			{
				lhs = "<C-e>",
				desc = "Harpoon menu",
				callback = function()
					local hp = harpoon()
					hp.ui:toggle_quick_menu(hp:list())
				end,
			},
			{
				lhs = "<S-h>",
				desc = "Harpoon previous file",
				callback = function()
					navigate("prev")
				end,
			},
			{
				lhs = "<S-l>",
				desc = "Harpoon next file",
				callback = function()
					navigate("next")
				end,
			},
			{
				lhs = "<leader>1",
				desc = "which_key_ignore",
				callback = function()
					harpoon():list():select(1)
				end,
			},
			{
				lhs = "<leader>2",
				desc = "which_key_ignore",
				callback = function()
					harpoon():list():select(2)
				end,
			},
			{
				lhs = "<leader>3",
				desc = "which_key_ignore",
				callback = function()
					harpoon():list():select(3)
				end,
			},
			{
				lhs = "<leader>4",
				desc = "which_key_ignore",
				callback = function()
					harpoon():list():select(4)
				end,
			},
		},
		config = function()
			local hp = harpoon()
			hp:setup({
				settings = {
					save_on_toggle = true,
				},
			})

			hp:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						hp.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open vertical split" })

					vim.keymap.set("n", "<C-s>", function()
						hp.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open split" })

					vim.keymap.set("n", "<C-t>", function()
						hp.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr, desc = "Harpoon open tab" })
				end,
			})
		end,
	},
}
