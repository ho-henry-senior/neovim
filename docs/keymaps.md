# Keymaps

Custom mappings and high-value workflow shortcuts. Not every built-in Vim command — just what's specific to this config or easy to miss.

## Discoverability

- WhichKey covers most leader mappings — pause after `<leader>` to see them.
- `<leader>?` shows buffer-local keymaps.
- Plugin-managed buffers (neotest summary, explorer, etc.) often expose their own help on `?`.
- `:MapTable` opens a generated table of all mappings.

## Core Navigation and Editing

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader><space>` | Smart file picker |
| Normal | `<leader>ff` | Find files |
| Normal | `<leader>sg` | Grep |
| Normal | `<leader>e` | File explorer |
| Normal / Visual | `j` / `k` | Move by display line when no count is given |
| Normal | `<leader>cf` | Format buffer |
| Normal | `<leader>gg` | Open LazyGit |
| Normal | `<leader>aa` | Explain current buffer with Copilot |
| Insert | `<C-l>` | Accept Copilot suggestion |

## Sessions

- Start `nvim` in a project directory with no file arguments to restore the last session for that directory.
- `<leader>qs` — load the session for the current working directory.
- `<leader>ql` — load the most recent session overall.
- `<leader>qS` — select a saved session.
- `<leader>qd` — disable session saving for the current exit.
- `<leader>qx` — delete the current project's saved session and skip the next auto-save.

## Easy to Miss

Mappings outside the leader namespace, or ones WhichKey doesn't surface as clearly.

| Mode | Shortcut | Action |
| --- | --- | --- |
| Insert | `<C-l>` | Accept Copilot suggestion |
| Insert | `<C-j>` | Next Copilot suggestion |
| Insert | `<C-k>` | Previous Copilot suggestion |
| Insert | `<C-h>` | Dismiss Copilot suggestion |
| Normal | `<C-h/j/k/l>` | Move between windows |
| Terminal | `<C-h/j/k/l>` | Move between windows from terminal mode |
| Terminal | `<Esc><Esc>` | Leave terminal insert mode |
| Normal | `<C-/>` | Toggle floating terminal |
| Terminal | `<C-/>` | Close floating terminal |
| Visual | `<A-j>` / `<A-k>` | Move selected lines down / up |
| Normal | `z0` | Fix spelling of word under cursor |
| Visual | `p` | Paste without overwriting the unnamed register |
| Normal | `<C-c>` | Copy entire file to system clipboard |
| Normal | `<S-h>` / `<S-l>` | Previous / next buffer |

## Workflows

### AI

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader>aA` | Copilot auth |
| Normal | `<leader>at` | Copilot toggle |
| Normal | `<leader>as` | Copilot status |
| Normal | `<leader>ac` | Open Copilot Chat |
| Normal / Visual | `<leader>aa` | Explain buffer or selection |

### Files, Search, and Explorer

| Shortcut | Action |
| --- | --- |
| `<leader><space>` | Smart file picker |
| `<leader>e` | File explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fc` | Find config files |
| `<leader>fr` | Recent files |
| `<leader>fp` | Open project |
| `<leader>fCf` | Copy full file path |
| `<leader>fCn` | Copy file name |
| `<leader>fCr` | Copy relative path |
| `<leader>sg` | Grep |
| `<leader>sw` | Grep word or visual selection |
| `<leader>sB` | Grep open buffers |
| `<leader>sb` | Buffer lines |
| `<leader>sk` | Keymaps |
| `<leader>sc` | Command history |

### Tests

`<leader>tn`, `<leader>tf`, and `<leader>to` are available in supported test buffers. `<leader>ta` and `<leader>ts` work in supported JavaScript, TypeScript, Python, and .NET projects.

| Shortcut | Action |
| --- | --- |
| `<leader>t?` | Explain when test mappings are available |
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run tests in current file |
| `<leader>ta` | Run all tests in project |
| `<leader>ts` | Test summary toggle |
| `<leader>to` | Open test output |

### Buffers and Tabs

| Shortcut | Action |
| --- | --- |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bb` | Buffer picker |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>[` / `<leader><tab>]` | Previous / next tab |

### Git

Hunk navigation and staging (`]h`, `<leader>gh*`) are buffer-local and active in any file tracked by git.

| Shortcut | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `]H` / `[H` | Last / first hunk |
| `ih` | Select hunk (visual and operator mode) |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghR` | Reset buffer |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line |
| `<leader>ghB` | Blame buffer |
| `<leader>ght` | Deleted toggle |
| `<leader>ghd` | Diff against index |
| `<leader>ghD` | Diff against previous commit |
| `<leader>gd` | Diff working tree |
| `<leader>gD` | Diff staged changes |
| `<leader>gf` | Diff current file against HEAD |
| `<leader>gF` | Diff current file against arbitrary ref |
| `<leader>gH` | Current file history in log picker |
| `<leader>gV` | Current file history as diff view |
| `<leader>gv` | Line range history (visual mode) |
| `<leader>gx` | Close all diff views |
| `<leader>gc` | Compare working tree against ref |
| `<leader>gC` | Compare two refs |
| `<leader>g2` | Diff two arbitrary files |
| `<leader>gm` | Resolve merge conflicts |
| `<leader>gg` | Open LazyGit |
| `<leader>gb` | Git branches picker |
| `<leader>gl` | Git log picker |
| `<leader>gs` | Git status picker |
| `<leader>gS` | Git stash picker |
| `<leader>gB` | Open file or selection in remote |

### Formatting, Diagnostics, and UI

| Shortcut | Action |
| --- | --- |
| `<leader>cf` | Format buffer |
| `<leader>cF` | Format injected languages |
| `<leader>cn` | Show formatter info |
| `<leader>n` | Notification history |
| `<leader>ud` | Diagnostics toggle |
| `<leader>uv` | Diagnostic virtual text toggle |
| `<leader>ut` | Treesitter toggle |
| `<leader>ug` | Indent guides toggle |
| `<leader>ur` | Clear search highlight and refresh |
| `<leader>ci` | Inspect highlight groups at cursor |
| `<leader>cI` | Inspect Treesitter tree |

Markdown, git commit, and other prose buffers automatically enable wrap and spell checking (British English, with English fallback).

## Reference

### Filetype Notes

- `.txt` files are treated as Markdown.
- `.env` files are treated as dotenv.
- `*.njk` is treated as HTML.
- `tsconfig*.json` and `jsconfig*.json` are treated as JSONC.
- Large files trigger `snacks.bigfile`, disabling Treesitter, LSP inlay hints, and diagnostics.
