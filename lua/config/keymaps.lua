local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Go to different windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- Keep cursor centred when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zvzz'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zvzz'", { expr = true, desc = "Previous search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

local function qf_next(direction)
	local info = vim.fn.getqflist({ idx = 0, size = 0 })
	local count = vim.v.count1
	local target = info.idx + direction * count

	if info.size == 0 then
		vim.notify("Quickfix list is empty", vim.log.levels.INFO)
		return
	end

	if target < 1 then
		vim.notify("Beginning of quickfix results", vim.log.levels.INFO)
		return
	end

	if target > info.size then
		vim.notify("End of quickfix results", vim.log.levels.INFO)
		return
	end

	local command = direction > 0 and "cnext" or "cprev"
	vim.cmd(command .. " " .. count)
end

map("n", "[q", function()
	qf_next(-1)
end, { desc = "Previous quickfix" })
map("n", "]q", function()
	qf_next(1)
end, { desc = "Next quickfix" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- ------------------------------------------------------------------------- }}}

-- Better paste
-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
map("x", "p", function()
	return vim.v.register == '"' and '"_dP' or "p"
end, { expr = true, noremap = true, silent = true, desc = "Paste without overwriting unnamed register" })

-- Copy whole file content to clipboard with C-c
map("n", "<C-c>", ":%y+<CR>", opts)

-- Visual -- Stay in visual mode after indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Fix Spell checking
map("n", "z0", "1z=", {
	desc = "Fix word under cursor",
})

map("n", "<leader>fcf", function()
	local p = vim.fn.expand("%:p")
	vim.fn.setreg("+", p)
	vim.notify("Copied full file path: " .. p)
end, { desc = "Copy full path" })

map("n", "<leader>fcn", function()
	local n = vim.fn.expand("%:t")
	vim.fn.setreg("+", n)
	vim.notify("Copied file name: " .. n)
end, { desc = "Copy file name" })

map("n", "<leader>fcr", function()
	local full = vim.fn.expand("%:p")
	local rel = vim.fn.fnamemodify(full, ":.")
	vim.fn.setreg("+", rel)
	vim.notify("Copied relative path: " .. rel)
end, { desc = "Copy relative path" })

-- vim.pack keymaps
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>")
map("n", "<leader>pd", function()
	vim.ui.input({ prompt = "Plugin name to delete: " }, function(input)
		if input and input ~= "" then
			pcall(vim.pack.del, { input })
		end
	end)
end, { desc = "Delete plugin" })

map("n", "<leader>qg", function()
	vim.ui.input({ prompt = "Git diff ref (default: HEAD): " }, function(ref)
		if ref == nil then
			return
		end
		ref = ref == "" and "HEAD" or ref
		local files = vim.fn.systemlist({ "git", "diff", "--name-only", ref })
		if vim.v.shell_error ~= 0 then
			vim.notify("git diff failed: " .. table.concat(files, "\n"), vim.log.levels.ERROR)
			return
		end
		if #files == 0 then
			vim.notify("No changed files for: " .. ref, vim.log.levels.INFO)
			return
		end
		local items = vim.tbl_map(function(f)
			return { filename = f, valid = 1 }
		end, files)
		require("lib.quickfix").set_items("git diff " .. ref, items)
	end)
end, { desc = "Git diff files → quickfix" })

map("n", "<leader>mm", function()
	require("plugins.markdown.mermaid").preview()
end, { desc = "Mermaid preview" })
