local M = {}

local refresh_timer = nil

local function modules()
	local ok_snacks, Snacks = pcall(require, "snacks")
	local ok_git, Git = pcall(require, "snacks.explorer.git")
	local ok_tree, Tree = pcall(require, "snacks.explorer.tree")

	if not ok_snacks or not ok_git or not ok_tree then
		return
	end

	return Snacks, Git, Tree
end

function M.refresh_git_status()
	local Snacks, Git, Tree = modules()
	if not Snacks then
		return
	end

	local pickers = Snacks.picker.get({ source = "explorer", tab = false })
	for _, picker in ipairs(pickers) do
		if picker and not picker.closed then
			local cwd = picker:cwd()
			Git.refresh(cwd)
			Tree:refresh(cwd)
			picker.list:set_target()
			picker:find({ refresh = true })
		end
	end
end

function M.invalidate_git_status(cwd)
	local Snacks, Git = modules()
	if not Snacks then
		return
	end

	cwd = cwd or Snacks.git.get_root() or vim.fn.getcwd(0)
	Git.refresh(cwd)
end

function M.open()
	M.invalidate_git_status()
	require("snacks").explorer()
end

function M.setup()
	vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
		group = vim.api.nvim_create_augroup("snacks_explorer_git_status", { clear = true }),
		callback = function()
			if refresh_timer then
				refresh_timer:stop()
				refresh_timer:close()
				refresh_timer = nil
			end
			refresh_timer = vim.defer_fn(function()
				refresh_timer = nil
				M.refresh_git_status()
			end, 200)
		end,
	})
end

return M
