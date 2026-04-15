# Brew Formulae

- neovim >= 0.12
- ripgrep
- fd
- tree-sitter-cli
- lua-language-server
- node
- python
- stylua
- lazygit

Also install the language servers in the opening comment of each file in `./lsp/`

## Wezterm Setup

This Wezterm setup permits:

- Ctrl+/ to open a terminal split
- Left Alt + 3 to type # or any 'composed' combinations
- Right Alt to be used as normal Alt key (main use Alt + j or k in Visual mode to move selected
  lines up and down.)

```
local wezterm = require("wezterm")

return {
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
  font = wezterm.font("JetBrainsMono Nerd Font"),

  keys = {
    {
      key = "/",
      mods = "CTRL",
      action = wezterm.action.SendKey { key = "_", mods = "CTRL" },
    },
  },
}
```
