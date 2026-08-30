# Workflows

Workflow-specific notes. Use [keymaps.md](keymaps.md) as the canonical shortcut reference and [motions.md](motions.md) for bracket motions.

## AI

Copilot has three surfaces: inline insert-mode suggestions, the Copilot panel, and Copilot Chat. Global enable/disable and buffer-local attach/detach are separate so a noisy file can opt out without disabling suggestions everywhere.

Inside the Copilot panel, `R` refreshes suggestions. CopilotChat can also send structured output into quickfix: `gqd` sends code diff blocks, and `gqa` sends assistant answers.

## Harpoon

Harpoon is for the small working set of files currently in focus. Delete lines from the Harpoon menu and close it with `q` or `<Esc>` to remove entries.

## Git

Hunk selection is buffer-local and active in any file tracked by git. Hunk navigation is listed in [motions.md](motions.md). Git workflows can send files, references, and hunks into quickfix when they become a task list rather than a one-off jump.

## Treesitter Text Objects

Treesitter textobjects are available in buffers where Treesitter is active. They cover functions, classes, parameters, comments, and statements; related bracket motions are listed in [motions.md](motions.md).

## Formatting, Diagnostics, and UI

Formatting is handled by Conform, with LSP formatting as a fallback. Diagnostics can be browsed inline, moved into quickfix, or filtered to errors only. UI toggles are grouped under `<leader>u`.

## Quickfix

The quickfix list is populated from diagnostics, LSP references, git diffs, git hunks, picker results, Grug-far results, and CopilotChat output. Navigate with `]q` / `[q`; at the beginning or end of the list, these mappings notify instead of showing the raw quickfix boundary error.

Use `:cope` or `:copen` to open the quickfix window. Close it with `:cclose`, or with `:q` from inside the quickfix window.

### Quickfix History

Quickfix keeps a history of result lists. This is useful after replacing grep results with diagnostics, references, or git output.

| Command | Action |
| --- | --- |
| `:chi` | Show quickfix history |
| `:{count}chi` | Make a specific quickfix list current |
| `:col` | Move to the previous quickfix list |
| `:cnew` | Move to the next quickfix list |

After switching lists, use `:cope` to inspect the current quickfix list.

### Location Lists

Location lists are the window-local sibling of quickfix lists. They are useful when different windows need different result sets. This config stays quickfix-first because diagnostics, search, references, git output, and AI output are treated as one global task list.

## Filetype Notes

- `.env` files are treated as dotenv.
- `*.njk` is treated as HTML.
- `tsconfig*.json` and `jsconfig*.json` are treated as JSONC.
- Large files trigger `snacks.bigfile`, disabling Treesitter, LSP inlay hints, and diagnostics.
