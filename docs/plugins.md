# Plugin Guide

These are the plugins currently loaded by `lua/plugins/init.lua`. The list is intentionally short: the config relies on native Neovim features where they are good enough and uses plugins mainly for gaps that still feel worth filling.

## Editing and Completion

- `saghen/blink.cmp`: completion UI and completion source integration. This is the main completion engine.
- `stevearc/conform.nvim`: formatting runner. It chooses formatters by filetype and handles format-on-save.
- `mistweaverco/kulala.nvim`: REST client support for `.http` and `.rest` request files, including request execution and response views.
- `nvim-treesitter/nvim-treesitter`: Treesitter parser support for highlighting, folds, and structure-aware editing.
- `nvim-treesitter/nvim-treesitter-textobjects`: textobjects and structural motions such as functions, classes, parameters, loops, and statements.

## AI

- `zbirenbaum/copilot.lua`: inline GitHub Copilot suggestions in insert mode.
- `CopilotC-Nvim/CopilotChat.nvim`: chat and “explain this code” workflows on top of Copilot.
- `nvim-lua/plenary.nvim`: utility dependency used by CopilotChat.

## Navigation, Search, and UI

- `folke/snacks.nvim`: the main UI/workflow plugin. It provides the picker, explorer, terminal, notifications, toggles, and big-file handling. The more ornamental UI features such as the dashboard, dimming, animation, smooth scrolling, and custom status column are intentionally disabled.
- `folke/which-key.nvim`: shows leader-key groupings and mapping hints. Useful for discoverability, especially when sharing the config.
- `nvim-lualine/lualine.nvim`: statusline, tabline, and split-window labels. See [ui.md](ui.md) for the UI goals.
- `nvim-tree/nvim-web-devicons`: file icons used by several UI plugins.

## Git and Refactoring

- `lewis6991/gitsigns.nvim`: inline git hunks, blame, staging/resetting hunks, and diff helpers.
- `tduyng/vdiff.nvim`: side-by-side git diff and merge views.
- `MagicDuck/grug-far.nvim`: search-and-replace UI for project-wide changes.

## Testing

- `nvim-neotest/neotest`: test runner framework and UI for running the nearest test, file, or project test suite from inside Neovim.
- `nvim-neotest/neotest-jest`: Jest adapter for JavaScript and TypeScript projects.
- `nvim-neotest/neotest-python`: Python adapter, configured here for `unittest` projects.
- `Issafalcon/neotest-dotnet`: .NET adapter for C# test projects using xUnit, NUnit, or MSTest.
- local Mocha adapter: JavaScript test support for Mocha projects, kept in-repo under `lua/plugins/neotest/`.
- `nvim-neotest/nvim-nio`: async dependency used by neotest.

## Writing and Markdown

- `MeanderingProgrammer/render-markdown.nvim`: rich inline rendering for headings, callouts, code blocks, checkboxes, tables, and links.
