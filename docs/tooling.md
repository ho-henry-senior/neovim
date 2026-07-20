# Tooling

## Required

### Homebrew

- `neovim` `>= 0.12`
- `ripgrep`
- `fd`
- `tree-sitter-cli` — builds the Kulala HTTP parser for `.http` and `.rest` files
- `lua-language-server`
- `node`
- `python`
- `ruff` — Python linting, fixes, import sorting, formatting, and LSP diagnostics
- `stylua`
- `marksman`

### npm

- `bash-language-server`
- `vscode-langservers-extracted` — provides CSS, HTML, and JSON LSP servers
- `typescript`
- `typescript-language-server`
- `yaml-language-server`
- `pyright`
- `prettier` — formats JS, TS, JSON, CSS, HTML, Markdown, YAML

```sh
npm install -g \
  bash-language-server \
  vscode-langservers-extracted \
  typescript \
  typescript-language-server \
  yaml-language-server \
  pyright \
  prettier
```

### .NET

```sh
dotnet tool install --global csharpier
dotnet tool install --global roslyn-language-server \
  --prerelease \
  --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json
export PATH="$HOME/.dotnet/tools:$PATH"
```

## Optional

### Homebrew

- `lazygit`
- `hunk` — review-first terminal diff viewer (`brew install modem-dev/tap/hunk`)
- `terraform-ls`
- `harper-ls` — prose and spell checking in Markdown and text buffers
- `terraform`
- `dotnet` — C# LSP, C# formatting, and .NET test support. `lsp/roslyn_ls.lua` sets `DOTNET_ROOT` and `DOTNET_ROOT_ARM64` to the Homebrew path (`/opt/homebrew/opt/dotnet/libexec`) so `roslyn-language-server` can locate the runtime when installed via Homebrew.

### npm

- `eslint`
- `vscode-eslint-language-server`
- `hunkdiff` — alternative install for the `hunk` CLI

### Project-local

- `jest` — required for neotest Jest support in JS/TS projects
- `mocha` — required for neotest Mocha support
- `.venv` or `venv` — required for Python test support when project dependencies are not on `python`

## Verification

- `just check` — load Neovim headlessly, fail if the config or plugins error
- `just fmt-check` — verify Lua formatting with `stylua --check`
- `just validate` — run both (may also install missing `vim.pack` plugins)

## WezTerm

This config requires a few keys to be sent reliably:

- `<C-/>` toggles the floating terminal
- Left Alt allows composed characters (e.g. `#`)
- Right Alt acts as a regular modifier for `<A-j>` / `<A-k>`

```lua
local wezterm = require("wezterm")

return {
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
  font = wezterm.font("JetBrainsMono Nerd Font"),

  keys = {
    {
      key = "/",
      mods = "CTRL",
      action = wezterm.action.SendKey { key = "_", mods = "CTRL" },
    },
  },
}
```

## Troubleshooting

- **Missing venv**: Python tests may be discovered but fail at runtime due to missing imports.
- **Missing `tree-sitter-cli`**: `.http`/`.rest` files may fail to highlight until the `kulala_http` parser has been built once.
- **Missing Copilot auth**: AI mappings load, but suggestions and chat will not work.
- **Missing `hunk`**: `:HunkDiff`, `:HunkShow`, and `<leader>gh` will notify instead of opening the review UI.
- **"No tests found" on first keypress**: neotest discovers test positions asynchronously after loading. If a test key is pressed immediately after opening a file, the first attempt may fail; a second press will work once discovery is complete.
