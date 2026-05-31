# Plugin Guide

## Editing and Completion

- **blink.cmp** — completion engine and source integration.
- **conform.nvim** — formatting runner; picks formatters by filetype and handles format-on-save.
- **kulala.nvim** — REST client for `.http` and `.rest` files; runs requests and shows responses without leaving Neovim.
- **nvim-treesitter** — Treesitter parsers for syntax highlighting, folding, and structured editing.
- **nvim-treesitter-textobjects** — structural motions and textobjects on top of Treesitter: functions, classes, parameters, loops, and statements.

## AI

- **copilot.lua** — inline GitHub Copilot suggestions in insert mode.
- **CopilotChat.nvim** — chat and explain-this-code workflows on top of Copilot.
- **plenary.nvim** — utility library required by CopilotChat.

## Navigation, Search, and UI

- **snacks.nvim** — the main UI and workflow plugin; provides the file picker, grep, explorer, terminal, notifications, and toggles. The dashboard, animations, smooth scrolling, and custom status column are intentionally disabled.
- **which-key.nvim** — shows leader key groups and mapping hints after a short pause.
- **lualine.nvim** — statusline, tabline, and per-window labels for splits. See [ui.md](ui.md).
- **nvim-web-devicons** — file type icons used by snacks and lualine.

## Git and Refactoring

- **gitsigns.nvim** — gutter hunk markers, inline blame, and hunk-level staging and resetting.
- **vdiff.nvim** — side-by-side diff and three-way merge views.
- **grug-far.nvim** — project-wide search and replace with a persistent UI.

## Testing

- **neotest** — test runner framework; runs the nearest test, current file, or full suite from inside Neovim.
- **neotest-jest** — Jest adapter for JavaScript and TypeScript projects.
- **neotest-python** — Python adapter, configured for `unittest` projects.
- **neotest-dotnet** — .NET adapter for xUnit, NUnit, and MSTest projects.
- local Mocha adapter — Mocha support for JavaScript projects, kept in-repo under `lua/plugins/neotest/`.
- **nvim-nio** — async library required by neotest.

## Writing and Markdown

- **render-markdown.nvim** — inline rendering for Markdown headings, callouts, code blocks, checkboxes, and tables. See [markdown.md](markdown.md).
