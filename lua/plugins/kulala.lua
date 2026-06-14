return {
	{
		src = "https://github.com/mistweaverco/kulala.nvim",
		name = "kulala.nvim",
		ft = "http",
		opts = {
			global_keymaps = true,
			global_keymaps_prefix = "<leader>r",
			kulala_keymaps_prefix = "",
		},
		module = "kulala",
		config = function(spec, opts)
			local function ensure_kulala_parser()
				local plugin_root = vim.fn.stdpath("data") .. "/site/pack/core/opt/kulala.nvim"
				local parser_root = plugin_root .. "/lua/tree-sitter"
				local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
				local parser_ext = vim.fn.has("win32") == 1 and "dll" or vim.fn.has("macunix") == 1 and "dylib" or "so"
				local parser_path = parser_dir .. "/kulala_http." .. parser_ext

				if vim.uv.fs_stat(parser_path) or vim.fn.executable("tree-sitter") ~= 1 then
					return
				end

				vim.fn.mkdir(parser_dir, "p")

				local result = vim
					.system({
						"tree-sitter",
						"build",
						"-o",
						parser_path,
					}, { cwd = parser_root })
					:wait()

				if result.code ~= 0 then
					vim.notify("Failed to build Kulala Treesitter parser", vim.log.levels.WARN)
				end
			end

			ensure_kulala_parser()
			require(spec.module).setup(opts)
		end,
	},
}
