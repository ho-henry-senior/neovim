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
dotnet tool install --global csharp-ls
export PATH="$HOME/.dotnet/tools:$PATH"
```

## Optional

### Homebrew

- `lazygit`
- `terraform-ls`
- `harper-ls` — prose and spell checking in Markdown and text buffers
- `terraform`
- `dotnet` — C# LSP and .NET test support

### npm

- `eslint`
- `vscode-eslint-language-server`

### Python

- `black` or `ruff` — Python formatting

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
