# Tooling

## Required Software

### Homebrew Formulae

- `neovim` `>= 0.12`
- `ripgrep`
- `fd`
- `tree-sitter-cli`
- `lua-language-server`
- `node`
- `python`
- `stylua`
- `lazygit`
- `marksman`
- `terraform-ls`
- `harper-ls`

### npm Packages

- `bash-language-server`
- `vscode-langservers-extracted`
- `typescript`
- `typescript-language-server`
- `yaml-language-server`
- `pyright`
- `prettier`
- `eslint`
- `vscode-eslint-language-server`

Example:

```sh
npm install -g \
  bash-language-server \
  vscode-langservers-extracted \
  typescript \
  typescript-language-server \
  yaml-language-server \
  pyright \
  prettier \
  eslint \
  vscode-eslint-language-server
```

## Notes

- `vscode-langservers-extracted` provides the CSS, HTML, and JSON LSP servers.
- `prettier` is required for formatting JavaScript, TypeScript, JSON, CSS, HTML, Markdown, YAML, and related files.
- Python formatting uses `ruff_format` or `black`, so at least one of those should exist in your environment.
- Terraform formatting uses `terraform fmt`, so install `terraform` if you edit Terraform regularly.
- A Nerd Font is recommended. The WezTerm example below uses `JetBrainsMono Nerd Font`.
- GitHub Copilot access is required if you want inline suggestions and Copilot Chat.

## WezTerm

This configuration assumes a terminal setup that makes a few keys reliable:

- `<C-/>` should be sent correctly so it can toggle the floating terminal.
- Left Alt should still allow composed characters such as `#`.
- Right Alt should behave like a regular Alt modifier for mappings such as `<A-j>` and `<A-k>`.

Example `wezterm.lua`:

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

Why this matters:

- Neovim sees `<C-_>` and `<C-/>` as the same key in many terminals.
- This config uses that key for the `snacks` terminal.
- Visual line movement uses Alt-based mappings.

## Clipboard

System clipboard sync is enabled via `unnamedplus` for local sessions. In SSH sessions it is disabled automatically by checking `SSH_TTY`, which avoids clipboard problems in remote terminals.

## Prettier

Formatting prefers a project-local Prettier config if one exists. Otherwise it falls back to `~/.prettierrc`.
