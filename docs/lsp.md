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

- `gd`: go to definition. This enhances the built-in `gd`, which is a text search, not an LSP jump.
- `<leader>cl`: fix all
- `gai` / `gao`: incoming / outgoing call hierarchy

## Stock Neovim LSP Defaults

Not remapped here, so they transfer to any Neovim 0.11+ setup:

- `gra`: code action
- `grn`: rename
- `grr`: references
- `gri`: implementation
- `grt`: type definition
- `K`: hover

Diagnostic bracket motions are listed in [motions.md](motions.md).
