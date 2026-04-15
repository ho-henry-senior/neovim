# LSP

## Configured by Default

- Bash
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

The per-server configs live under `lsp/`.

## Optional On-Demand Server

- ESLint

To enable an on-demand server such as ESLint, set:

```lua
vim.g.lsp_on_demands = { "eslint_ls" }
```

## Default LSP Mappings

- `gd`: go to definition
- `K`: hover
- `<leader>ca`: code actions
- `<leader>cl`: fix all
- `<leader>cd`: line diagnostics
- `]d` / `[d`: next / previous diagnostic
- `]e` / `[e`: next / previous error
- `]w` / `[w`: next / previous warning
- `<leader>ss`: document symbols
- `<leader>sS`: workspace symbols
- `gai` / `gao`: incoming / outgoing call hierarchy
