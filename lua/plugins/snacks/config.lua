local M = {}

-- Core Snacks feature policy lives here: which modules are enabled, which are
-- intentionally disabled, and the heavier picker/explorer defaults that shape
-- the overall workflow.
M.options = {
	animate = { enabled = false }, -- Keep visual behavior simpler and closer to stock Neovim.
	bigfile = { -- Provides optimizations for handling large files by disabling expensive features like treesitter, LSP inlay hints, and diagnostics when a file exceeds a specified size threshold.
		enabled = true,
		size = 1.5 * 1024 * 1024, -- 1.5MB threshold
		setup = function(ctx)
			-- Disable treesitter (disables highlights, folds, indentexpr)
			vim.cmd("syntax clear")
			vim.treesitter.stop(ctx.buf)
			vim.wo[0].foldmethod = "manual"
			vim.wo[0].foldexpr = ""

			-- Disable LSP features that are expensive on large files
			vim.schedule(function()
				vim.lsp.inlay_hint.enable(false, { bufnr = ctx.buf })
				vim.lsp.document_color.enable(false, ctx.buf)
			end)

			-- Keep diagnostics off for huge files
			vim.diagnostic.enable(false, { bufnr = ctx.buf })

			-- Disable indent guides
			vim.b[ctx.buf].snacks_indent = false
		end,
	},
	dashboard = { enabled = false },
	dim = { enabled = false }, -- Keep inactive windows unstyled unless explicitly needed.
	explorer = { enabled = true, replace_netrw = true }, -- Provides a built-in file explorer with features like file operations, git integration, diagnostics, and customizable views.
	indent = { enabled = true }, -- Provides enhanced indentation guides with support for different styles (e.g., lines, dots, trees) and customizable colors and behavior.
	input = { enabled = true }, -- Provides a consistent and extensible interface for handling user input across various Snacks features, with support for customizable keybindings, input validation, and integration with the rest of the Snacks ecosystem.
	layout = { enabled = true }, -- Provides a flexible and customizable layout system for arranging and resizing various Snacks UI components (e.g., pickers, explorers, terminals) with support for different screen sizes and orientations.
	notifier = { enabled = true }, -- Provides a unified interface for displaying notifications, with support for different backends (e.g., native, telescope) and customizable formatting and behavior.
	scope = { enabled = true }, -- Provides a way to define and manage custom scopes (e.g., project, git branch, filetype) that can be used to filter and organize various Snacks features like pickers and explorers.
	scroll = { enabled = false }, -- Prefer stock scrolling behavior.
	statuscolumn = { enabled = false }, -- Use stock Neovim sign/number columns.
	terminal = { enabled = true }, -- Provides a built-in terminal emulator with features like floating windows, customizable keybindings, and integration with the rest of the Snacks ecosystem.
	toggle = { enabled = true }, -- Provides a convenient way to toggle various editor features on and off with customizable keybindings.
	words = { enabled = true }, -- Provides enhanced navigation for jumping between occurrences of the word under the cursor, with support for counting and direction.
	zen = { enabled = false }, -- Disable focus modes unless they prove useful enough to keep.
	picker = {
		sources = {
			files = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"build/*",
					"coverage/*",
					"dist/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/.node-gyp/**",
				},
			},
			grep = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.venv/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"**/yarn.lock",
					"**/build/**",
					"**/build*/**",
					"**/coverage/**",
					"**/dist/**",
					"**/certificates/**",
					"**/target/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
				},
			},
			grep_buffers = {},
			explorer = {
				hidden = true, -- Show hidden files by default
				ignored = true, -- Respect .gitignore and other ignore files
				supports_live = true, -- Update explorer in real-time as files change
				auto_close = true, -- Close when focus move away from explorer
				diagnostics = true, -- Show diagnostics in the explorer
				diagnostics_open = false, -- Don't open diagnostics by default
				focus = "list", -- Focus the file list when opening the explorer
				follow_file = true, -- Automatically focus the current file in the explorer
				git_status = true, -- Show git status in the explorer
				git_status_open = false, -- Don't open git status by default
				git_untracked = true, -- Show untracked files in git status
				jump = { close = true }, -- Auto-close explorer after jumping to a file
				tree = true, -- Show files in a tree structure rather than a flat list
				watch = true, -- Automatically update explorer when files change
				exclude = {
					".yarn/cache/**",
					".yarn/install/**",
					".yarn/install*",
					".yarn/releases/**",
					".pnpm-store",
					".venv",
					".DS_Store",
					"**/.node-gyp/**",
				},
			},
		},
	},
}

return M.options
