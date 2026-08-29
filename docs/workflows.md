# Workflows

Workflow-specific mappings and notes. See [keymaps.md](keymaps.md) for the short reference.

## AI

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

Copilot panel mappings:

| Shortcut | Action |
| --- | --- |
| `R` | Refresh suggestions |
| `]]` / `[[` | Next / previous suggestion |
| `<Enter>` | Accept suggestion |

## Harpoon

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

## Git

Hunk selection is buffer-local and active in any file tracked by git. Hunk navigation is listed in [motions.md](motions.md).

| Shortcut | Action |
| --- | --- |
| `ih` | Select hunk (visual and operator mode) |
| `<leader>gf` | Current file history in log picker |
| `<leader>gg` | Open LazyGit |
| `<leader>gh` | Open Hunk review UI for the current repo diff |
| `<leader>gH` | Open Hunk review UI for `HEAD` |
| `<leader>gl` | Git log picker |
| `<leader>gL` | Git log for current line |
| `<leader>gp` | Git diff picker |
| `<leader>gr` | Open file or selection in remote |

## Treesitter Text Objects

Available in any buffer where Treesitter is active. Treesitter bracket motions are listed in [motions.md](motions.md).

| Shortcut | Object |
| --- | --- |
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `aa` / `ia` | Parameter outer / inner |
| `ad` | Comment |
| `as` | Statement |

## Formatting, Diagnostics, and UI

| Shortcut | Action |
| --- | --- |
| `<leader>cf` | Format buffer |
| `<leader>n` | Notification history |
| `<leader>ud` | Diagnostics toggle |
| `<leader>uv` | Diagnostic virtual text toggle |
| `<leader>ua` | Tabline toggle |
| `<leader>ut` | Treesitter toggle |
| `<leader>ub` | Dark background toggle |
| `<leader>ug` | Indent guides toggle |
| `<leader>uC` | Pick colorscheme |
| `<leader>ur` | Clear search highlight and refresh |

## Quickfix

The quickfix list is populated from multiple sources and navigated with `]q` / `[q`.
At the beginning or end of the list, these mappings notify instead of showing
the raw quickfix boundary error.

Use `:cope` or `:copen` to open the quickfix window. Close it with `:cclose`,
or with `:q` from inside the quickfix window.

### Populating quickfix

| Shortcut | Source |
| --- | --- |
| `<leader>qd` | All diagnostics (project-wide) |
| `<leader>qe` | Errors only (project-wide) |
| `<leader>qr` | LSP references for symbol under cursor |
| `<leader>qg` | Git diff files — prompts for a ref, defaults to `HEAD` |
| `<leader>qh` | Git hunks in current buffer |
| `<leader>qH` | Git hunks across all open buffers |
| `<C-q>` | Send current picker results to quickfix (inside any Snacks picker) |

### Automatic population

- **Grug-far** — `<localleader>q` inside the grug-far buffer sends all matches to quickfix.
- **CopilotChat** — `gqd` sends code diff blocks to quickfix; `gqa` sends assistant answers.

### Quickfix history

Quickfix keeps a history of result lists. This is useful after replacing grep
results with diagnostics, references, or git output.

| Command | Action |
| --- | --- |
| `:chi` | Show quickfix history |
| `:{count}chi` | Make a specific quickfix list current |
| `:col` | Move to the previous quickfix list |
| `:cnew` | Move to the next quickfix list |

After switching lists, use `:cope` to inspect the current quickfix list.

### Location lists

Location lists are the window-local sibling of quickfix lists. They are useful
when different windows need different result sets. This config stays
quickfix-first because diagnostics, search, references, git output, and AI
output are treated as one global task list.

## Filetype Notes

- `.env` files are treated as dotenv.
- `*.njk` is treated as HTML.
- `tsconfig*.json` and `jsconfig*.json` are treated as JSONC.
- Large files trigger `snacks.bigfile`, disabling Treesitter, LSP inlay hints, and diagnostics.
