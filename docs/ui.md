# UI

This config keeps the main editor UI close to stock Neovim while using `lualine.nvim` for labels and status information that would otherwise require a large custom `statusline`, `tabline`, and `winbar` setup.

## Goals

- Keep the bottom statusline useful without turning it into a dashboard.
- Make the active tab and active window easy to identify.
- Show clear labels for tabs and split windows.
- Prefer standard Neovim highlight groups so good colorschemes can style the UI naturally.
- Avoid hardcoded colors and heavily branded statusline styling.

## Statusline

The bottom statusline is global, matching `laststatus = 3`.

It shows:

- mode
- git branch, diff, and diagnostics
- current file
- encoding, file format, filetype, and LSP status
- progress and cursor location

Separators are intentionally plain:

```lua
component_separators = { left = "│", right = "│" }
section_separators = { left = "", right = "" }
```

This keeps the layout readable while avoiding powerline-style separators.

## Tabline

Tabs are rendered by lualine's `tabs` component.

The active and inactive tabs use standard Neovim statusline highlight groups:

```lua
tabs_color = {
  active = "StatusLine",
  inactive = "StatusLineNC",
}
```

This makes the active tab easier to see than the default `TabLineSel` / `TabLine` pairing while staying theme-friendly.

## Winbar

The winbar is used only when the current tab has multiple normal windows.

This keeps single-window editing quiet, while split-window layouts get visible per-window file labels. Inactive windows use `StatusLineNC`-style colouring so the active split remains clear.

## Theme Compatibility

The lualine theme is set to `auto`, and the config relies on standard highlight groups such as `StatusLine`, `StatusLineNC`, `TabLine`, and `TabLineSel`.

Themes may vary in contrast, but this approach avoids custom colour choices and should adapt cleanly to most well-maintained colorschemes.
