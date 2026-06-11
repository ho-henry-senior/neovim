local M = {}

local plugin_modules = {
	"plugins.blink",
	"plugins.conform",
	"plugins.copilot",
	"plugins.git",
	"plugins.grug-far",
	"plugins.harpoon",
	"plugins.kulala",
	"plugins.lualine",
	"plugins.markdown",
	"plugins.treesitter",
	"plugins.neotest",
	"plugins.snacks",
	"plugins.whichkey",
}

function M.setup()
	if M._did_setup then
		return
	end

	for _, module_name in ipairs(plugin_modules) do
		local module = require(module_name)
		if type(module) == "table" and type(module.setup) == "function" then
			module.setup()
		end
	end

	M._did_setup = true
end

return M
