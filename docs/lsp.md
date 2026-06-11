# LSP

## Configured by Default

- Bash
- C# / .NET
- CSS / SCSS / LESS
- Harper for prose, spell, and style checks
- HTML
- JSON / JSONC
- Lua
- Markdown
- Pyright for Python
- Terraform
- TypeScript / JavaScript
- YAML

The per-server configs live under `lsp/`. Install commands are listed in [tooling.md](tooling.md).

## Optional On-Demand Server

- ESLint

ESLint is optional because `ts_ls` already covers general JavaScript and TypeScript features; ESLint is only useful when a project actually uses it and you want lint diagnostics and fix-all support from the editor.

To enable it, set `vim.g.lsp_on_demands` early in `init.lua`:

```lua
vim.g.lsp_on_demands = { "eslint_ls" }
```

## Default LSP Mappings

These are the extra mappings this config adds on top of Neovim's built-in LSP behaviour.

- `gd`: go to definition
- `K`: hover
- `<leader>ca`: code actions
- `<leader>cl`: fix all
- `gai` / `gao`: incoming / outgoing call hierarchy

Diagnostic bracket motions are listed in [motions.md](motions.md).
