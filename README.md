# Neovim Configuration

A personal Neovim setup built around stock Neovim 0.12, `vim.pack`, native LSP, and a small set of focused plugins. 

## Install

1. Clone this repo to `~/.config/nvim`.
2. Install required tools from [docs/tooling.md](docs/tooling.md).
3. Start Neovim. Run `<leader>pu` to install plugins.
4. Run `just check` to check everything loaded correctly.
5. Authenticate Copilot with `<leader>aA` if you use it.

## Start Here

- `<leader><space>` — smart file picker
- `<leader>sg` — search project
- `<leader>e` — file explorer
- `<leader>cf` — format buffer
- `<leader>gg` — LazyGit
- `<leader>gh` — Hunk review UI for the current repo diff
- `<leader>aa` — explain buffer with Copilot Chat
- `<leader>ap` — toggle Copilot panel (`R` refreshes suggestions inside the panel)
- Start `nvim` in a project directory with no file arguments to restore the session for that directory.

## Going Deeper

- [docs/keymaps.md](docs/keymaps.md) — short keymap reference
- [docs/workflows.md](docs/workflows.md) — workflow-specific mappings and notes
- [docs/motions.md](docs/motions.md) — bracket motions and other movement references
- [docs/plugins.md](docs/plugins.md) — what each plugin does and why it's here
- [docs/lsp.md](docs/lsp.md) — configured language servers and LSP mappings
- [docs/markdown.md](docs/markdown.md) — Markdown and prose support
- [docs/ui.md](docs/ui.md) — statusline, tabline, and winbar
- [docs/tooling.md](docs/tooling.md) — required tools, WezTerm config, and troubleshooting

## Layout

- `init.lua` — entrypoint; sets leader, loads config and plugins
- `lua/config/` — options, keymaps, LSP wiring, sessions, and autocmds
- `lua/plugins/` — plugin specs, one file per configured plugin
- `lua/integrations/` — wrappers for external tools exposed through the editor workflow (for example Hunk and LazyGit)
- `lua/lib/pack.lua` — small `vim.pack` helper for plugin specs, dependencies, lazy triggers, and global plugin keymaps
- `after/ftplugin/` — filetype-local settings (wrap, spell, conceallevel) loaded after the main config and any plugin ftplugins, one file per filetype
- `lsp/` — per-server LSP configs
- `nvim-pack-lock.json` — plugin lock file

## Design

Stays close to stock Neovim rather than building on a large framework. Sessions, LSP, and package management use native Neovim features. Plugin specs are a small local layer over `vim.pack`, not a replacement plugin manager. Plugins fill gaps where native features aren't good enough yet.

Prefer native motions, command history, quickfix/location lists, and editor primitives before adding plugin mappings. Leader mappings are reserved for actions that are frequent, clearer than the native command, or not covered well by stock Neovim.

Avoid mappings that only rename clear native commands. Favour editor knowledge that transfers to Vim on other servers, and document native commands where they are already concise.
