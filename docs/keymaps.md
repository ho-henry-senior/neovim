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
| Normal | `<leader>h` | Add current file to Harpoon |
| Normal | `<leader>H` | Remove current file from Harpoon |
| Normal | `<C-e>` | Harpoon menu |
| Normal / Visual | `j` / `k` | Move by display line when no count is given |
| Normal | `<leader>cf` | Format buffer |
| Normal | `<leader>gg` | Open LazyGit |
| Normal | `<leader>aa` | Explain current buffer with Copilot |
| Insert | `<C-l>` | Accept Copilot suggestion |

## Sessions

Start `nvim` in a project directory with no file arguments to restore the last session for that directory.

| Shortcut | Action |
| --- | --- |
| `<leader>qs` | Load project session |
| `<leader>ql` | Load last session |
| `<leader>qS` | Select session |
| `<leader>qd` | Skip session save |
| `<leader>qx` | Clear project session |

## Easy to Miss

Mappings outside the leader namespace, or ones WhichKey doesn't surface as clearly.

| Mode | Shortcut | Action |
| --- | --- | --- |
| Insert | `<C-l>` | Accept Copilot suggestion |
| Insert | `<C-j>` | Next Copilot suggestion |
| Insert | `<C-k>` | Previous Copilot suggestion |
| Insert | `<C-h>` | Dismiss Copilot suggestion |
| Copilot panel | `R` | Refresh Copilot panel suggestions |
| Copilot panel | `]]` / `[[` | Next / previous Copilot panel suggestion |
| Copilot panel | `<Enter>` | Accept Copilot panel suggestion |
| Normal | `<C-h/j/k/l>` | Move between windows |
| Terminal | `<C-h/j/k/l>` | Move between windows from terminal mode |
| Terminal | `<Esc><Esc>` | Leave terminal insert mode |
| Normal | `<C-/>` | Toggle floating terminal |
| Terminal | `<C-/>` | Close floating terminal |
| Normal | `<C-e>` | Harpoon menu |
| Normal | `<leader>1` ... `<leader>4` | Harpoon files 1-4 |
| Normal | `<S-h>` / `<S-l>` | Previous / next Harpoon file |
| Visual | `<A-j>` / `<A-k>` | Move selected lines down / up |
| Normal | `z0` | Fix spelling of word under cursor |
| Visual | `p` | Paste without overwriting the unnamed register |
| Normal | `<C-c>` | Copy entire file to system clipboard |

## Workflows

### AI

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader>aA` | Copilot auth |
| Normal | `<leader>at` | Copilot toggle |
| Normal | `<leader>aT` | Copilot toggle current buffer attach |
| Normal | `<leader>as` | Copilot status |
| Normal | `<leader>ac` | Open Copilot Chat |
| Normal | `<leader>ap` | Toggle Copilot panel |
| Normal / Visual | `<leader>aa` | Copilot explain buffer or selection |

`<leader>at` enables or disables Copilot globally. `<leader>aT` only attaches or detaches Copilot for the current buffer.

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
| `<leader>sb` | Search buffer |

### Inspect

| Shortcut | Action |
| --- | --- |
| `<leader>ia` | Autocmds |
| `<leader>ic` | Commands |
| `<leader>ih` | Highlights |
| `<leader>ii` | Icons |
| `<leader>ik` | Keymaps |

### Harpoon

| Shortcut | Action |
| --- | --- |
| `<leader>h` | Add current file |
| `<leader>H` | Remove current file |
| `<C-e>` | Open Harpoon menu |
| `<leader>1` ... `<leader>4` | Jump to Harpoon file 1-4 |
| `<S-h>` / `<S-l>` | Previous / next Harpoon file |
| `<C-v>` | Open selected Harpoon file in vertical split from the menu |
| `<C-s>` | Open selected Harpoon file in split from the menu |
| `<C-t>` | Open selected Harpoon file in tab from the menu |

Delete lines from the Harpoon menu and close it with `q` or `<Esc>` to remove entries.

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

### Buffers

| Shortcut | Action |
| --- | --- |
| `<leader>bb` | Buffer picker |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers |

### Git

Hunk navigation and staging (`]h`, `<leader>gh*`) are buffer-local and active in any file tracked by git.

| Shortcut | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `]H` / `[H` | Last / first hunk |
| `ih` | Select hunk (visual and operator mode) |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line |
| `<leader>ghd` | Diff against index |
| `<leader>gf` | Current file history in log picker |
| `<leader>gg` | Open LazyGit |
| `<leader>gb` | Git branches picker |
| `<leader>gl` | Git log picker |
| `<leader>gL` | Git log for current line |
| `<leader>gp` | Git diff picker |
| `<leader>gs` | Git status picker |
| `<leader>gS` | Git stash picker |
| `<leader>gr` | Open file or selection in remote |

### Treesitter Text Objects and Motions

Available in any buffer where Treesitter is active.

#### Text objects (visual and operator-pending)

| Shortcut | Object |
| --- | --- |
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `aa` / `ia` | Parameter outer / inner |
| `ad` | Comment |
| `as` | Statement |

#### Motions

| Shortcut | Action |
| --- | --- |
| `]m` / `[m` | Next / previous function start |
| `]M` / `[M` | Next / previous function end |
| `]]` / `[[` | Next / previous class start |
| `]o` / `[o` | Next / previous loop start |

### Formatting, Diagnostics, and UI

| Shortcut | Action |
| --- | --- |
| `<leader>cf` | Format buffer |
| `<leader>cF` | Format injected languages |
| `<leader>cn` | Show formatter info |
| `<leader>n` | Notification history |
| `<leader>ud` | Diagnostics toggle |
| `<leader>uv` | Diagnostic virtual text toggle |
| `<leader>ua` | Tabline toggle |
| `<leader>ut` | Treesitter toggle |
| `<leader>ub` | Dark background toggle |
| `<leader>ug` | Indent guides toggle |
| `<leader>uC` | Pick colorscheme |
| `<leader>ur` | Clear search highlight and refresh |
| `<leader>ci` | Inspect highlight groups at cursor |
| `<leader>cI` | Inspect Treesitter tree |

Markdown, text, and git commit buffers automatically enable wrap and spell checking (British English, with English fallback).

## Reference

### Filetype Notes

- `.txt` files are treated as Markdown.
- `.env` files are treated as dotenv.
- `*.njk` is treated as HTML.
- `tsconfig*.json` and `jsconfig*.json` are treated as JSONC.
- Large files trigger `snacks.bigfile`, disabling Treesitter, LSP inlay hints, and diagnostics.
