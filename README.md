# Neovim Configuration

This is a fast, keyboard-first Neovim setup built around stock Neovim 0.12 features, `vim.pack`, native LSP, and a small set of focused plugins.

## Design Goals

- Stay close to core Neovim rather than building around a large framework.
- Keep startup and mental overhead low.
- Use native Neovim features where they are good enough now: LSP, sessions, package management, diagnostics.
- Prefer strong editing defaults for software work and pleasant writing defaults for Markdown and prose.
- Keep the configuration inspectable: most behavior lives in a small number of files under `lua/config` and `lua/plugins`.

## Layout

- `init.lua`: entrypoint, sets leader and loads config and plugins.
- `lua/config`: core editor behavior such as options, keymaps, diagnostics, autocmds, sessions, and LSP wiring.
- `lua/plugins`: plugin install and setup files, one file per feature area.
- `lsp`: per-server native LSP configs.
- `snippets`: custom snippets.
- `nvim-pack-lock.json`: plugin lock file used by `vim.pack`.

## Core Behavior

- Leader key is `<Space>`.
- Sessions are restored automatically per working directory when Neovim starts with no file arguments.
- Sessions are saved automatically on exit if real file buffers were open.
- Completion uses `blink.cmp`.
- Formatting uses `conform.nvim`.
- GitHub Copilot suggestions are enabled in insert mode.
- File navigation, grep, explorer, scratch buffers, terminal, notifications, and Zen mode are provided by `snacks.nvim`.
- Treesitter powers highlighting, textobjects, and folding.
- The active colorscheme is Neovim's built-in `default`, chosen for broad compatibility with core UI features and plugin highlight groups.

## Installation

1. Clone this repo to `~/.config/nvim`.
2. Install the required software from [docs/tooling.md](docs/tooling.md).
3. Run `just validate` to verify Neovim and `stylua` are wired up correctly.
4. Start Neovim.
5. Run `<leader>pu` to update/install packages with `vim.pack.update()`.
6. Authenticate Copilot with `<leader>aA` if you use it.

Notes:

- `vim.pack` installs the plugins declared in this repo.
- External language servers, formatters, and CLI tools still need to be installed separately.

## Documentation

- [docs/plugins.md](docs/plugins.md): plugin guide and what each plugin is for.
- [docs/tooling.md](docs/tooling.md): required vs optional software, verification commands, WezTerm, clipboard, and formatter notes.
- [docs/keymaps.md](docs/keymaps.md): shortcut reference, especially mappings that are easy to miss.
- [docs/lsp.md](docs/lsp.md): configured language servers, install guidance, and on-demand LSP setup.
