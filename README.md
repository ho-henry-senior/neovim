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
- `<leader>aa` — explain buffer with Copilot Chat
- `<leader>ap` — toggle Copilot panel (`R` refreshes suggestions inside the panel)
- Start `nvim` in a project directory with no file arguments to restore the session for that directory.

## Going Deeper

- [docs/keymaps.md](docs/keymaps.md) — full keymap reference, organised from basics to deeper workflows
- [docs/plugins.md](docs/plugins.md) — what each plugin does and why it's here
- [docs/lsp.md](docs/lsp.md) — language servers and install commands
- [docs/markdown.md](docs/markdown.md) — Markdown and prose support
- [docs/ui.md](docs/ui.md) — statusline, tabline, and winbar
- [docs/tooling.md](docs/tooling.md) — required tools, WezTerm config, and troubleshooting

## Layout

- `init.lua` — entrypoint; sets leader, loads config and plugins
- `lua/config/` — options, keymaps, LSP wiring, sessions, and autocmds
- `lua/plugins/` — plugin setup, one file per feature area
- `lsp/` — per-server LSP configs
- `nvim-pack-lock.json` — plugin lock file

## Design

Stays close to stock Neovim rather than building on a large framework. Sessions, LSP, and package management use native Neovim features. Plugins fill gaps where native features aren't good enough yet.
