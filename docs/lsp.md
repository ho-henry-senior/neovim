# LSP

## Configured by Default

- Bash
- C# / .NET via Roslyn
- CSS / SCSS / LESS
- Harper for prose, spell, and style checks
- HTML
- JSON / JSONC
- Lua
- Markdown
- Pyright for Python type checking and navigation
- Ruff for Python linting, fixes, import sorting, and formatting
- Terraform
- TypeScript / JavaScript
- ESLint for JS / TS linting and fix-all support
- YAML

The per-server configs live under `lsp/`. Install commands are listed in [tooling.md](tooling.md).

## Default LSP Mappings

These are the extra mappings this config adds on top of Neovim's built-in LSP behaviour.

- `gd`: go to definition
- `K`: hover
- `<leader>ca`: code actions
- `<leader>cl`: fix all
- `gai` / `gao`: incoming / outgoing call hierarchy

Diagnostic bracket motions are listed in [motions.md](motions.md).
