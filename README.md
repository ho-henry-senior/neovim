# Neovim Configuration

This is a fast, keyboard-first Neovim setup built around stock Neovim 0.12 features, `vim.pack`, native LSP, and a small set of focused plugins.

It is intended as a personal, opinionated Neovim config that is still simple enough to inspect, adapt, and share. It is not trying to be a general-purpose Neovim distribution or framework.

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
- `nvim-pack-lock.json`: plugin lock file used by `vim.pack`.

## Core Behavior

- Leader key is `<Space>`.
- Sessions are restored automatically per working directory when Neovim starts with no file arguments.
- Sessions are saved automatically on exit if real file buffers were open.
- Completion uses `blink.cmp`.
- Formatting uses `conform.nvim`.
- GitHub Copilot suggestions are enabled in insert mode.
- File navigation, grep, explorer, terminal, and notifications are provided by `snacks.nvim`.
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

## Start Here

If you are new to this config, focus on these first:

- `<leader>ff` to find files
- `<leader>sg` to grep
- `<leader>e` to open the file explorer
- `<leader>cf` to format the current buffer
- `<leader>gg` for git via LazyGit
- `<leader>aa` to explain the current buffer with Copilot Chat
- start `nvim` in a project directory with no file arguments to restore that project's session

Then use:

- [docs/keymaps.md](docs/keymaps.md) for day-to-day shortcuts, organized from basics to deeper workflows
- [docs/tooling.md](docs/tooling.md) for installation, optional tooling, WezTerm, and troubleshooting
- [docs/plugins.md](docs/plugins.md) for the plugin guide
- [docs/lsp.md](docs/lsp.md) for language-server details

## Who It Is For

- People who want to stay close to stock Neovim rather than adopt a large distribution.
- People who are happy to install external tooling such as language servers and formatters.
- People who prefer a small number of well-used plugins over a broad feature surface.

This config is probably not a good fit if you want a batteries-included Neovim distro with many preconfigured workflows out of the box.
