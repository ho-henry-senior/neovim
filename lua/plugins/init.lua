local specs = {}

local function add(module)
	vim.list_extend(specs, require(module))
end

add("plugins.blink")
add("plugins.conform")
add("plugins.nvim-treesitter")
add("plugins.nvim-treesitter-textobjects")
add("plugins.lualine")
add("plugins.snacks")
add("plugins.which-key")
add("plugins.gitsigns")
add("plugins.render-markdown")
add("plugins.markdown-preview")
add("plugins.harpoon")
add("plugins.copilot")
add("plugins.copilot-chat")
add("plugins.grug-far")
add("plugins.kulala")
add("plugins.neotest")

return specs
