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

## Install Guidance

### Code-Focused Servers

- Bash: `npm install -g bash-language-server`
- CSS / HTML / JSON: `npm install -g vscode-langservers-extracted`
- Lua: `brew install lua-language-server`
- Python: `npm install -g pyright`
- Terraform: `brew install terraform-ls`
- TypeScript / JavaScript: `npm install -g typescript typescript-language-server`
- YAML: `npm install -g yaml-language-server`

### Writing-Focused Servers

- Markdown: `brew install marksman`
- Prose / spell / style checks: `brew install harper-ls`

## Optional On-Demand Server

- ESLint

Install with:

```sh
npm install -g eslint vscode-eslint-language-server
```

Why it is optional:

- `ts_ls` already provides general JavaScript and TypeScript language features.
- ESLint is mainly useful when a project actually uses ESLint and you want lint diagnostics and fix-all support from the editor.

To enable an on-demand server such as ESLint, set `vim.g.lsp_on_demands` before `config.lsp` is loaded:

```lua
vim.g.lsp_on_demands = { "eslint_ls" }
```

In practice that means setting it early in `init.lua` or another module loaded before `require("config.lsp")`.

## Default LSP Mappings

These are the extra mappings this config adds on top of Neovim's built-in LSP behavior.

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
