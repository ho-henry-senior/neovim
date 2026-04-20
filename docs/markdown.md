# Markdown

This config treats Markdown and prose as a first-class workflow, but keeps the setup fairly small.

## Defaults

Markdown and other text-like buffers automatically:

- enable wrap
- enable spell checking
- prefer British English with fallback to English

Related filetype behaviour:

- `.txt` files are treated as Markdown
- `gitcommit` buffers get the same writing defaults

## Mappings

### Rendering and Preview

- `<leader>mm`: toggle inline Markdown rendering
- `<leader>mp`: toggle browser preview

These are different tools:

- rendering stays inside Neovim and improves readability while editing
- preview opens the Markdown preview plugin for a browser-style view

### Editing Helpers

Visual mode:

- `<leader>mb`: wrap selection in `**...**`
- `<leader>mi`: wrap selection in `*...*`
- `<leader>mc`: wrap selection in `` `...` ``
- `<leader>ml`: turn the selection into `[text]()` and place the cursor inside the URL

Normal mode:

- `<leader>m<`: promote the current heading by one level
- `<leader>m>`: demote the current heading by one level
- `<leader>mh`: insert a horizontal rule
- `<leader>mx`: toggle a checkbox on the current line

Checkbox behaviour:

- `- [ ] item` becomes `- [x] item`
- `- [x] item` becomes `- [ ] item`
- `- item` becomes `- [ ] item`

## Plugins

Markdown support currently uses:

- `render-markdown.nvim` for inline rendering
- `markdown-preview.nvim` for browser preview

## Notes

- The visual editing mappings are intended for characterwise and linewise visual selections.
- If you want a complete mapping overview beyond what the clue window shows, use `:MapTable`.
