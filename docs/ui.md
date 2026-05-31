# UI

## Statusline

A single global statusline at the bottom of the window. It shows:

- current mode
- git branch, diff summary, and diagnostics
- current file
- filetype, encoding, file format, and active LSP servers
- cursor position and scroll progress

## Tabline

Tabs are shown in the tabline when more than one tab is open. The active tab uses `StatusLine` highlighting; inactive tabs use `StatusLineNC`. This makes the active tab visually distinct without needing custom colours.

## Winbar

A per-window label appears above each split when the current tab has more than one normal window open. Single-window editing gets no winbar. Inactive splits are dimmed relative to the active one.

## Theming

The config uses Neovim's built-in `default` colorscheme and relies on standard highlight groups (`StatusLine`, `StatusLineNC`, `TabLine`, `TabLineSel`) throughout. Switching to a different colorscheme should work without any UI configuration changes.
