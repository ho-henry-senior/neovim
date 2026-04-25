vim.pack.add({
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/Issafalcon/neotest-dotnet",
})

vim.cmd.packadd("nvim-nio")

local neotest = require("neotest")
local nio = require("nio")
local tests = require("plugins.neotest.tests")

local function get_neotest_client()
	local _, client = debug.getupvalue(neotest.run.get_tree_from_args, 1)
	return client
end

local function ensure_test_positions(file_path)
	local client = get_neotest_client()
	if not client or not file_path or file_path == "" then
		return
	end

	local adapter_id = client:get_adapter(file_path)
	if not adapter_id then
		client:_update_adapters(vim.fs.dirname(file_path))
		adapter_id = client:get_adapter(file_path)
	end

	if adapter_id and not client:get_position(file_path, { adapter = adapter_id }) then
		client:_update_positions(file_path, { adapter = adapter_id })
	end
end

local function ensure_project_positions(root, file_path)
	local client = get_neotest_client()
	if not client or not root or root == "" then
		return nil
	end

	local adapter_id = file_path and client:get_adapter(file_path) or nil
	if not adapter_id then
		client:_update_adapters(root)
		adapter_id = client:get_adapter(root)
	end

	if adapter_id then
		client:_update_positions(root, { adapter = adapter_id })
	end

	return adapter_id
end

local function run_nearest_test()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		ensure_test_positions(file_path)

		local tree = neotest.run.get_tree_from_args(nil, false)
		if tree then
			neotest.run.run()
			return
		end

		neotest.run.run(file_path)
	end)
end

local function run_file_tests()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		ensure_test_positions(file_path)
		neotest.run.run(file_path)
	end)
end

local function run_project_tests()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		local root = tests.project_root(file_path) or vim.fn.getcwd()
		local adapter_id = ensure_project_positions(root, file_path)
		neotest.run.run({ root, adapter = adapter_id })
	end)
end

local function toggle_test_summary()
	nio.run(function()
		local file_path = vim.fn.expand("%:p")
		local root = tests.project_root(file_path) or vim.fn.getcwd()
		ensure_project_positions(root, file_path)
		neotest.summary.toggle()
	end)
end

local function with_test_support(fn)
	return function()
		local file_path = vim.fn.expand("%:p")
		if not tests.is_test_file(file_path) then
			vim.notify(
				"Test mappings are only available in supported JavaScript, TypeScript, or Python test buffers.",
				vim.log.levels.INFO
			)
			return
		end

		fn()
	end
end

local function with_project_support(fn)
	return function()
		local file_path = vim.fn.expand("%:p")
		if not tests.project_root(file_path) then
			vim.notify(
				"Run-all is only available in supported JavaScript, TypeScript, or Python test projects.",
				vim.log.levels.INFO
			)
			return
		end

		fn()
	end
end

vim.keymap.set("n", "<leader>t?", function()
	vim.notify("Test mappings are available in supported JavaScript, TypeScript, or Python test buffers.")
end, { desc = "Test Mapping Help" })
vim.keymap.set("n", "<leader>tn", with_test_support(run_nearest_test), { desc = "Run Nearest Test" })
vim.keymap.set("n", "<leader>tf", with_test_support(run_file_tests), { desc = "Run File Tests" })
vim.keymap.set("n", "<leader>ta", with_project_support(run_project_tests), { desc = "Run All Tests" })
vim.keymap.set("n", "<leader>ts", with_project_support(toggle_test_summary), { desc = "Toggle Test Summary" })
vim.keymap.set(
	"n",
	"<leader>to",
	with_test_support(function()
		neotest.output.open({ enter = true })
	end),
	{ desc = "Open Test Output" }
)

neotest.setup({
	summary = {
		animated = false,
		follow = false,
		mappings = {
			expand = { "<CR>", "l" },
			parent = "h",
			output = "o",
			short = "O",
			attach = "a",
			jumpto = "i",
			stop = "u",
			run = "r",
			mark = "m",
			run_marked = "R",
			clear_marked = "M",
			target = "t",
			clear_target = "T",
			next_failed = "J",
			prev_failed = "K",
			watch = "w",
			help = "?",
		},
	},
	adapters = tests.adapters(),
})
