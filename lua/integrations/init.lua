-- The `./integrations` directory is a Lua module that serves as a centralized location for configuring and managing various integrations within a Neovim setup.
-- It allows users to easily set up and customize different tools that enhance the functionality of Neovim.
local M = {}

function M.setup()
	require("integrations.hunk").setup()
end

return M
