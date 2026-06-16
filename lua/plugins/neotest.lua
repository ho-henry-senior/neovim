local tests = require("plugins.neotest.tests")

local _neotest

local function load_neotest()
	if _neotest then
		return
	end

	_neotest = require("neotest")

	_neotest.setup({
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
		quickfix = {
			enabled = true,
			open = true,
		},
	})
end

local function with_project_support(fn)
	return function()
		local file_path = vim.fn.expand("%:p")
		local root = tests.project_root(file_path) or vim.fn.getcwd()
		load_neotest()
		fn(root)
	end
end

local function with_test_support(fn)
	return function()
		local file_path = vim.fn.expand("%:p")
		if not tests.is_test_file(file_path) then
			vim.notify(
				"Test mappings are only available in supported JavaScript, TypeScript, Python, or C# test buffers.",
				vim.log.levels.INFO
			)
			return
		end

		load_neotest()
		fn()
	end
end

return {
	{
		src = "https://github.com/nvim-neotest/neotest",
		name = "neotest",
		ft = { "cs", "python", "javascript", "typescript", "typescriptreact", "javascriptreact" },
		dependencies = {
			{
				src = "https://github.com/nvim-neotest/nvim-nio",
				name = "nvim-nio",
			},
			{
				src = "https://github.com/nvim-neotest/neotest-jest",
				name = "neotest-jest",
			},
			{
				src = "https://github.com/nvim-neotest/neotest-python",
				name = "neotest-python",
			},
			{
				src = "https://github.com/Issafalcon/neotest-dotnet",
				name = "neotest-dotnet",
			},
		},
		keys = {
			{
				lhs = "<leader>t?",
				desc = "Test mapping help",
				callback = function()
					vim.notify("Test mappings are available in supported JavaScript, TypeScript, Python, or C# test buffers.")
				end,
			},
			{
				lhs = "<leader>tn",
				desc = "Run nearest test",
				callback = with_test_support(function()
					_neotest.run.run()
				end),
			},
			{
				lhs = "<leader>tf",
				desc = "Run file tests",
				callback = with_test_support(function()
					_neotest.run.run(vim.fn.expand("%:p"))
				end),
			},
			{
				lhs = "<leader>ta",
				desc = "Run all tests",
				callback = with_project_support(function(root)
					_neotest.run.run(root)
				end),
			},
			{
				lhs = "<leader>ts",
				desc = "Test summary toggle",
				callback = with_project_support(function()
					_neotest.summary.toggle()
				end),
			},
			{
				lhs = "<leader>to",
				desc = "Open test output",
				callback = with_test_support(function()
					_neotest.output.open({ enter = true })
				end),
			},
		},
		config = load_neotest,
	},
}
