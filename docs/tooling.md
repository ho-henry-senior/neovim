# Tooling

## Required Software

These are the tools needed for the core config and the default validation flow. Workflow-specific language tools are listed separately below.

### Homebrew Formulae

- `neovim` `>= 0.12`
- `ripgrep`
- `fd`
- `tree-sitter-cli`
- `lua-language-server`
- `node`
- `python`
- `stylua`
- `marksman`

### npm Packages

- `bash-language-server`
- `vscode-langservers-extracted`
- `typescript`
- `typescript-language-server`
- `yaml-language-server`
- `pyright`
- `prettier`

Example:

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

### .NET Tools

- `csharp-ls`

Example:

```sh
dotnet tool install --global csharp-ls
```

Make sure the .NET tools directory is on `PATH`:

```sh
export PATH="$HOME/.dotnet/tools:$PATH"
```

## Optional Software

These tools unlock specific workflows, but the config can still load and basic validation can still pass without them.

### Homebrew Formulae

- `lazygit`
- `terraform-ls`
- `harper-ls`
- `terraform`
- `dotnet`

### npm Packages

- `eslint`
- `vscode-eslint-language-server`

### Python Packages

- `black` or `ruff`

Optional project-local tools:

- `jest`: required inside a JavaScript or TypeScript project if you want to use the built-in test mappings through `neotest-jest`
- `mocha`: required inside a JavaScript project if you want to use the built-in test mappings for Mocha projects
- `dotnet`: required for C# language support and .NET test mappings
- Python test mappings expect a valid project-local `.venv` or `venv` when project dependencies are not available from `python`.

## Basics

### Verification

- `just check`: load Neovim headlessly and fail if the config or plugins error.
- `just fmt-check`: verify Lua formatting with `stylua --check`.
- `just validate`: run both checks. This may also install missing `vim.pack` plugins declared by the config.

### Notes

- `vscode-langservers-extracted` provides the CSS, HTML, and JSON LSP servers.
- `tree-sitter-cli` is used to build Kulala's `kulala_http` parser for `.http` and `.rest` request files when the parser binary is missing.
- `prettier` is required for formatting JavaScript, TypeScript, JSON, CSS, HTML, Markdown, YAML, and related files.
- Python formatting uses `ruff_format` or `black`, so at least one of those should exist if you want Python formatting.
- Terraform formatting uses `terraform fmt`, so install `terraform` if you edit Terraform regularly.
- JavaScript and TypeScript test support uses `neotest-jest` for Jest projects and a local neotest adapter for Mocha projects.
- Python test support uses `neotest-python`, configured for `unittest` projects.
- .NET test support uses `neotest-dotnet` for C# test projects using xUnit, NUnit, or MSTest.
- Jest test runs also load `.env`, `.env.local`, `.env.test`, and `.env.test.local` from the nearest project root, with more specific files overriding more general ones.
- A Nerd Font is recommended. The WezTerm example below uses `JetBrainsMono Nerd Font`.
- GitHub Copilot access and authentication are required if you want inline suggestions and Copilot Chat.

## Advanced

### WezTerm

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

### Clipboard

System clipboard sync is enabled via `unnamedplus` for local sessions. In SSH sessions it is disabled automatically by checking `SSH_TTY`, which avoids clipboard problems in remote terminals.

### Prettier

Formatting prefers a project-local Prettier config if one exists. Otherwise it falls back to `~/.prettierrc`.

## Troubleshooting

- Missing `ripgrep`: grep-based search and some picker workflows will degrade or fail.
- Missing `fd`: file picking can fall back to slower behaviour depending on source.
- Missing `prettier`: JavaScript, TypeScript, JSON, HTML, CSS, Markdown, YAML, and similar formatting will not run.
- Missing `stylua`: `just fmt`, `just fmt-check`, and Lua formatting support will fail.
- Missing `tree-sitter-cli`: `.http` and `.rest` request files may fail to start Kulala Treesitter highlighting until the `kulala_http` parser has already been built.
- Missing `lazygit`: `<leader>gg` will not work.
- Missing `terraform` or `terraform-ls`: Terraform formatting or LSP support will be unavailable.
- Missing `harper-ls`: prose and spell/style LSP checks for Markdown and text buffers will be unavailable.
- Missing `dotnet` or `csharp-ls`: C# LSP and .NET test support will be unavailable.
- Missing or broken Python project venv: Python tests may be discovered but fail at runtime because project dependencies cannot import.
- Missing Copilot auth: AI mappings load, but Copilot suggestions and Copilot Chat will not be usable.
