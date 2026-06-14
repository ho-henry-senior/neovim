# Plugins

Plugin installation and loading is handled by a small local helper in `lua/lib/pack.lua` on top of Neovim's built-in `vim.pack`.

Each configured plugin has a top-level file in `lua/plugins/`. Specs use a small, explicit shape:

- `src`, `name`, and `version` are passed through to `vim.pack`.
- `dependencies` keeps dependency-only plugins with the plugin that needs them.
- `event`, `ft`, `cmd`, and `lazy = true` control lazy loading.
- `keys` is the standard place for global plugin-owned keymaps.
- `opts` plus `module` handles the common `require(module).setup(opts)` case.
- `init` runs before a plugin is loaded, for plugin globals or other pre-load setup.
- `config` is reserved for plugin-specific setup that does not fit the common fields.

Buffer-local and dynamic mappings stay in plugin callbacks such as `on_attach`, special-buffer setup, or plugin UI creation hooks.

## Editing and Completion

- **[blink.cmp](https://github.com/saghen/blink.cmp)** — completion engine and source integration.
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** — formatting runner; picks formatters by filetype and handles format-on-save.
- **[kulala.nvim](https://github.com/mistweaverco/kulala.nvim)** — REST client for `.http` and `.rest` files; runs requests and shows responses without leaving Neovim.
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** — Treesitter parsers for syntax highlighting, folding, and structured editing.
- **[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)** — structural motions and textobjects on top of Treesitter: functions, classes, parameters, loops, and statements.

## AI

- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)** — inline GitHub Copilot suggestions in insert mode.
- **[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)** — chat and explain-this-code workflows on top of Copilot.
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** — utility library required by CopilotChat.

## Navigation, Search, and UI

- **[snacks.nvim](https://github.com/folke/snacks.nvim)** — the main UI and workflow plugin; provides the file picker, grep, explorer, terminal, notifications, and toggles. The dashboard, animations, smooth scrolling, and custom status column are intentionally disabled.
- **[harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)** — project-local file marks for quickly jumping between the small set of files currently in focus.
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** — shows leader key groups and mapping hints after a short pause.
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** — statusline, tabline, and per-window labels for splits. See [ui.md](ui.md).
- **[nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** — file type icons used by snacks and lualine.

## Git and Refactoring

- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** — gutter hunk markers, inline blame, and hunk-level staging and resetting.
- **[grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim)** — project-wide search and replace with a persistent UI.

## Testing

- **[neotest](https://github.com/nvim-neotest/neotest)** — test runner framework; runs the nearest test, current file, or full suite from inside Neovim. Loads automatically when opening C#, Python, or JavaScript/TypeScript files. The summary panel shows results and supports re-running tests with `r`/`R`, navigating with `<CR>`/`l`/`h`, jumping to source with `i`, opening output with `o`, and cycling failures with `J`/`K`.
- **[neotest-jest](https://github.com/nvim-neotest/neotest-jest)** — Jest adapter for JavaScript and TypeScript projects.
- **[neotest-python](https://github.com/nvim-neotest/neotest-python)** — Python adapter, configured for `unittest` projects.
- **[neotest-dotnet](https://github.com/Issafalcon/neotest-dotnet)** — .NET adapter for xUnit, NUnit, and MSTest projects.
- local Mocha adapter — Mocha support for JavaScript projects, kept in-repo under `lua/plugins/neotest/`.
- **[nvim-nio](https://github.com/nvim-neotest/nvim-nio)** — async library required by neotest.

## Writing and Markdown

- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)** — inline rendering for Markdown headings, callouts, code blocks, checkboxes, and tables. See [markdown.md](markdown.md).
- **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)** — browser preview for Markdown documents.
