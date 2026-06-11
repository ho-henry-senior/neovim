local M = {}

local config_modules = {
	"config.options",
	"config.keymaps",
	"config.session",
	"config.diagnostics",
	"config.autocmds",
	"config.usercmds",
	"config.lsp",
}

function M.setup()
	if M._did_setup then
		return
	end

	for _, module_name in ipairs(config_modules) do
		local module = require(module_name)
		if type(module) == "table" and type(module.setup) == "function" then
			module.setup()
		end
	end

	M._did_setup = true
end

return M
