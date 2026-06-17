# Keymaps

Custom mappings and high-value shortcuts. This is the short reference; workflow-specific mappings live in [workflows.md](workflows.md), and bracket motions live in [motions.md](motions.md).

## Discoverability

- WhichKey covers most leader mappings: pause after `<leader>`.
- `<leader>?` shows buffer-local keymaps.
- Plugin-managed buffers often expose their own help on `?`.
- `<leader>ik` opens the keymap picker.

## Core

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<leader><space>` | Smart file picker |
| Normal | `<leader>sg` | Search project |
| Normal | `<leader>e` | File explorer |
| Normal | `<C-e>` | Harpoon menu |
| Normal / Visual | `j` / `k` | Move by display line when no count is given |
| Normal | `<leader>cf` | Format buffer |
| Normal | `<leader>gg` | Open LazyGit |
| Normal | `<leader>aa` | Explain current buffer with Copilot |
| Insert | `<C-l>` | Accept Copilot suggestion |

## Native-First Extras

| Mode | Shortcut | Action |
| --- | --- | --- |
| Normal | `<C-h/j/k/l>` | Move between windows |
| Terminal | `<C-h/j/k/l>` | Move between windows from terminal mode |
| Terminal | `<Esc><Esc>` | Leave terminal insert mode |
| Normal | `<C-/>` | Toggle floating terminal |
| Terminal | `<C-/>` | Close floating terminal |
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
| `<leader>t` | Tests |
| `<leader>u` | UI |

## Search

| Shortcut | Action |
| --- | --- |
| `<leader>sg` | Search project |
| `<leader>sw` | Search project for word or selection |
| `<leader>sb` | Search buffer |
| `<leader>sr` | Search and replace |

## Files

| Shortcut | Action |
| --- | --- |
| `<leader><space>` | Smart file picker |
| `<leader>e` | File explorer |
| `<leader>fcf` | Copy full file path |
| `<leader>fcn` | Copy file name |
| `<leader>fcr` | Copy relative path |

## Buffers

| Shortcut | Action |
| --- | --- |
| `<leader>bb` | Buffer picker |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers |

## Inspect

| Shortcut | Action |
| --- | --- |
| `<leader>ia` | Autocmds |
| `<leader>ic` | Commands |
| `<leader>ii` | Icons |
| `<leader>ik` | Keymaps |

## Sessions

Start `nvim` in a project directory with no file arguments to restore the last session for that directory.

| Shortcut | Action |
| --- | --- |
| `<leader>Sc` | Clear project session |
