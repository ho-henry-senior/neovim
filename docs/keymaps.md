# Keymaps

Canonical shortcut reference. Workflow notes live in [workflows.md](workflows.md), bracket motions live in [motions.md](motions.md), and Markdown behaviour lives in [markdown.md](markdown.md).

## Discoverability

- WhichKey covers most leader mappings: pause after `<leader>`.
- `<leader>?` shows buffer-local keymaps.
- Plugin-managed buffers often expose their own help on `?`.
- `<leader>ik` opens the keymap picker.

## Core

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal / Visual | `j` / `k` | Move by display line when no count is given |
| Normal | `<C-h/j/k/l>` | Move between windows |
| Terminal | `<C-h/j/k/l>` | Move between windows from terminal mode |
| Terminal | `<Esc><Esc>` | Leave terminal insert mode |
| Normal / Terminal | `<C-/>` | Toggle floating terminal |
| Visual | `<A-j>` / `<A-k>` | Move selected lines down / up |
| Normal | `z0` | Fix spelling of word under cursor |
| Visual | `p` | Paste without overwriting the unnamed register |
| Normal | `<C-c>` | Copy entire file to system clipboard |

## Leader Groups

| Prefix | Group |
| --- | --- |
| `<leader>a` | AI |
| `<leader>b` | Buffers |
| `<leader>c` | Code |
| `<leader>f` | Files |
| `<leader>g` | Git |
| `<leader>i` | Inspect |
| `<leader>m` | Markdown |
| `<leader>p` | Plugins |
| `<leader>q` | Quickfix |
| `<leader>S` | Sessions |
| `<leader>r` | REST |
| `<leader>s` | Search |
| `<leader>u` | UI |

## AI

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader>aA` | Copilot auth |
| Normal | `<leader>at` | Toggle Copilot globally |
| Normal | `<leader>aT` | Toggle Copilot for current buffer |
| Normal | `<leader>as` | Copilot status |
| Normal | `<leader>ac` | Open Copilot Chat |
| Normal | `<leader>ap` | Toggle Copilot panel |
| Normal / Visual | `<leader>aa` | Explain buffer or selection with Copilot Chat |
| Insert | `<C-l>` | Accept Copilot suggestion |
| Insert | `<C-j>` / `<C-k>` | Next / previous Copilot suggestion |
| Insert | `<C-h>` | Dismiss Copilot suggestion |
| Copilot panel | `R` | Refresh suggestions |

## Buffers

| Shortcut | Action |
| --- | --- |
| `<leader>bb` | Buffer picker |
| `<leader>bd` | Delete current buffer |
| `<leader>bh` | Delete hidden buffers |
| `<leader>bo` | Delete other buffers |

## Code, Diagnostics, and Formatting

| Shortcut | Action |
| --- | --- |
| `<leader>cf` | Format buffer |
| `<leader>ca` | LSP code actions |
| `<leader>cl` | LSP fix all |
| `<leader>qd` | All diagnostics to quickfix |
| `<leader>qe` | Errors to quickfix |
| `<leader>qr` | LSP references to quickfix |

## Files and Search

| Shortcut | Action |
| --- | --- |
| `<leader><space>` | Smart file picker |
| `<leader>e` | File explorer |
| `<leader>fcf` | Copy full file path |
| `<leader>fcn` | Copy file name |
| `<leader>fcr` | Copy relative path |
| `<leader>sg` | Search project |
| `<leader>sw` | Search project for word or selection |
| `<leader>sb` | Search buffer |
| `<leader>sr` | Search and replace |

## Git

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal / Operator / Visual | `ih` | Select hunk |
| Normal | `<leader>gf` | Current file history in log picker |
| Normal | `<leader>gg` | Open LazyGit |
| Normal | `<leader>gh` | Open Hunk review UI for current repo diff |
| Normal | `<leader>gH` | Open Hunk review UI for `HEAD` |
| Normal | `<leader>gl` | Git log picker |
| Normal | `<leader>gL` | Git log for current line |
| Normal | `<leader>gp` | Git diff picker |
| Normal / Visual | `<leader>gr` | Open file or selection in remote |
| Normal | `<leader>qg` | Git diff files to quickfix |
| Normal | `<leader>qh` | Current buffer hunks to quickfix |
| Normal | `<leader>qH` | All open buffer hunks to quickfix |

## Harpoon

| Shortcut | Action |
| --- | --- |
| `<leader>h` | Add current file |
| `<leader>H` | Remove current file |
| `<C-e>` | Open Harpoon menu |
| `<leader>1` ... `<leader>4` | Jump to Harpoon file 1-4 |
| `<S-h>` / `<S-l>` | Previous / next Harpoon file |
| Harpoon menu `<C-v>` | Open selected file in vertical split |
| Harpoon menu `<C-s>` | Open selected file in split |
| Harpoon menu `<C-t>` | Open selected file in tab |

## Inspect

| Shortcut | Action |
| --- | --- |
| `<leader>ia` | Autocmds |
| `<leader>ic` | Commands |
| `<leader>ii` | Icons |
| `<leader>ik` | Keymaps |

## Markdown

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader>mt` | Toggle inline Markdown rendering |
| Normal | `<leader>mp` | Toggle browser Markdown preview |
| Normal | `<leader>mm` | Preview current Mermaid file or code fence |
| Visual | `<leader>mb` | Wrap selection in `**...**` |
| Visual | `<leader>mi` | Wrap selection in `*...*` |
| Visual | `<leader>mc` | Wrap selection in `` `...` `` |
| Visual | `<leader>ml` | Turn selection into `[text]()` |
| Normal | `gf` | Follow local inline Markdown link |
| Normal | `<leader>m<` / `<leader>m>` | Increase / decrease heading level |
| Normal | `<leader>mh` | Insert horizontal rule |
| Normal | `<leader>mx` | Toggle checkbox on current line |

## REST

Kulala uses `<leader>r` as its global keymap prefix for `.http` and `.rest` buffers.

## Sessions

Start `nvim` in a project directory with no file arguments to restore the last session for that directory.

| Shortcut | Action |
| --- | --- |
| `<leader>Sc` | Clear project session |

## Treesitter Text Objects

| Shortcut | Object |
| --- | --- |
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `aa` / `ia` | Parameter outer / inner |
| `ad` | Comment |
| `as` | Statement |

## UI

| Shortcut | Action |
| --- | --- |
| `<leader>n` | Notification history |
| `<leader>ud` | Diagnostics toggle |
| `<leader>uv` | Diagnostic virtual text toggle |
| `<leader>ua` | Tabline toggle |
| `<leader>ut` | Treesitter toggle |
| `<leader>ub` | Dark background toggle |
| `<leader>ug` | Indent guides toggle |
| `<leader>uC` | Pick colorscheme |
| `<leader>uf` | Autoformat toggle |
| `<leader>ur` | Clear search highlight and refresh |
