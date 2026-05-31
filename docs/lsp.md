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

The per-server configs live under `lsp/`.

## Install Guidance

### Code-Focused Servers

- Bash: `npm install -g bash-language-server`
- C# / .NET: `dotnet tool install --global csharp-ls`
- CSS / HTML / JSON: `npm install -g vscode-langservers-extracted`
- Lua: `brew install lua-language-server`
- Python: `npm install -g pyright`
- Terraform: `brew install terraform-ls`
- TypeScript / JavaScript: `npm install -g typescript typescript-language-server`
- YAML: `npm install -g yaml-language-server`

For C# / .NET, ensure global dotnet tools are on `PATH`:

```sh
export PATH="$HOME/.dotnet/tools:$PATH"
```

### Writing-Focused Servers

- Markdown: `brew install marksman`
- Prose / spell / style checks: `brew install harper-ls`

## Optional On-Demand Server

- ESLint

Install with:

```sh
npm install -g eslint vscode-eslint-language-server
```

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
- `<leader>cd`: line diagnostics
- `]d` / `[d`: next / previous diagnostic
- `]e` / `[e`: next / previous error
- `]w` / `[w`: next / previous warning
- `<leader>ss`: document symbols
- `<leader>sS`: workspace symbols
- `gai` / `gao`: incoming / outgoing call hierarchy
