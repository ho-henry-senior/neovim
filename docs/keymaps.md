# Keymaps

This file focuses on custom mappings and high-value workflow shortcuts from this config, not every built-in Vim command.

## Basics

These are the mappings and behaviours worth learning first if you want to use the config effectively without memorising everything.

### Discoverability

- WhichKey covers most leader mappings.
- `<leader>?` shows buffer-local keymaps.
- Plugin-managed buffers often expose their own local help on `?`, including the neotest summary window.
- `:MapTable` opens a generated table of mappings.

### Core Navigation and Editing

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader><space>` | Smart file picker |
| Normal | `<leader>ff` | Find files |
| Normal | `<leader>sg` | Grep |
| Normal | `<leader>e` | File explorer |
| Normal | `<S-h>` / `<S-l>` | Previous / next buffer |
| Normal / Visual | `j` / `k` | Move by display line when no count is given |
| Normal | `<leader>cf` | Format Buffer |
| Normal | `<leader>gg` | Open LazyGit |
| Normal | `<leader>aa` | Explain current buffer |
| Insert | `<C-l>` | Accept Copilot suggestion |

### Sessions

- Start `nvim` in a project directory with no file arguments to restore the last session for that directory.
- `<leader>qs`: load the session for the current working directory.
- `<leader>ql`: load the most recent session overall.
- `<leader>qS`: select a saved session.
- `<leader>qd`: disable session saving for the current exit.
- `<leader>qx`: delete the current project's saved session and skip the next auto-save.

### Shortcuts Easy to Miss

These are the mappings that are either outside the leader namespace or easy to forget because WhichKey does not surface them as clearly.

| Mode | Shortcut | Action |
| --- | --- | --- |
| Insert | `<C-l>` | Accept Copilot suggestion |
| Insert | `<C-j>` | Next Copilot suggestion |
| Insert | `<C-k>` | Previous Copilot suggestion |
| Insert | `<C-h>` | Dismiss Copilot suggestion |
| Normal | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between windows |
| Terminal | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between windows while in terminal |
| Terminal | `<Esc><Esc>` | Leave terminal insert mode |
| Normal | `<C-/>` | Toggle floating terminal |
| Terminal | `<C-/>` | Close floating terminal |
| Visual | `<A-j>` / `<A-k>` | Move selected lines down/up |
| Normal | `z0` | Spell-fix word under cursor |
| Visual | `p` | Paste without overwriting the unnamed register |
| Normal | `<C-c>` | Copy entire file to system clipboard |

## Workflows

### AI

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader>aA` | Copilot auth |
| Normal | `<leader>at` | Copilot toggle |
| Normal | `<leader>as` | Copilot status |
| Normal | `<leader>ac` | Open Copilot Chat |
| Normal | `<leader>aa` | Explain current buffer |
| Visual | `<leader>aa` | Explain selection |

### Files, Search, Explorer

| Shortcut | Action |
| --- | --- |
| `<leader><space>` | Smart file picker |
| `<leader>e` | File explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fc` | Find config files |
| `<leader>fr` | Recent files |
| `<leader>fp` | Open project |
| `<leader>sg` | Grep |
| `<leader>sw` | Grep word or visual selection |
| `<leader>sB` | Grep open buffers |
| `<leader>sb` | Buffer lines |
| `<leader>sk` | Keymaps |
| `<leader>sa` | Autocmds |
| `<leader>sc` | Command history |

### Tests

These mappings are always listed under `<leader>t`. Nearest, file, and output mappings run in supported test buffers; run-all and summary mappings run in supported JavaScript, TypeScript, Python, or .NET test projects.

| Shortcut | Action |
| --- | --- |
| `<leader>t?` | Explain when test mappings are available |
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run tests in current file |
| `<leader>ta` | Run all tests from the current project |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Open test output |

### Buffers and Tabs

| Shortcut | Action |
| --- | --- |
| `<leader>bb` | Buffer picker |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>[` / `<leader><tab>]` | Previous / next tab |
| `<leader>uu` | Undo tree |

### Git

| Shortcut | Action |
| --- | --- |
| `]h` / `[h` | Next / previous git hunk |
| `]H` / `[H` | Last / first git hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghR` | Reset buffer |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line |
| `<leader>ghB` | Blame buffer |
| `<leader>gd` | Diff working tree |
| `<leader>gD` | Diff staged changes |
| `<leader>gf` | Diff current file |
| `<leader>gF` | Diff current file against arbitrary ref |
| `<leader>gH` | Show current file history |
| `<leader>gV` | Open file history view |
| `<leader>gv` | Open line history view |
| `<leader>gc` | Compare against branch / commit / tag |
| `<leader>gC` | Compare two refs |
| `<leader>gm` | Resolve merge conflicts |
| `<leader>gg` | Open LazyGit |
| `<leader>gB` | Open current file/selection in remote |

### Formatting, Diagnostics, and UI

| Shortcut | Action |
| --- | --- |
| `<leader>cf` | Format Buffer |
| `<leader>cF` | Format Injected Languages |
| `<leader>cn` | Show Formatter Info |
| `<leader>n` | Notification History |
| `<leader>un` | Dismiss notifications |
| `<leader>uw` | Toggle wrap |
| `<leader>uL` | Toggle relative number |
| `<leader>ul` | Toggle line number |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uv` | Toggle diagnostic virtual text |
| `<leader>uc` | Toggle conceal level |
| `<leader>uA` | Toggle tabline |
| `<leader>uT` | Toggle Treesitter highlighting |
| `<leader>ub` | Toggle light/dark background |
| `<leader>ug` | Toggle indent guides |
| `<leader>uC` | Pick colorscheme |
| `<leader>z` | Toggle Zoom |
| `<leader>ur` | Clear search highlight and refresh |
| `<leader>ci` | Inspect cursor position highlight data |
| `<leader>cI` | Inspect Treesitter tree |

Markdown, git commit, and other text-like buffers automatically:

- enable wrap
- enable spell checking
- prefer British English with fallback to English

## Reference

### Filetype Notes

- `.txt` files are treated as Markdown.
- `.env` files are treated as dotenv files.
- `*.njk` is treated as HTML.
- `tsconfig*.json` and `jsconfig*.json` are treated as JSONC.
- Large files trigger `snacks.bigfile`, which disables some expensive UI and LSP features.
