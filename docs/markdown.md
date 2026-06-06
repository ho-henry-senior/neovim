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

### Rendering

- `<leader>mt`: toggle inline Markdown rendering
- `<leader>mp`: toggle browser Markdown preview, including Mermaid diagrams
- `<leader>mm`: preview the current Mermaid file or Mermaid code fence under the cursor

### Editing Helpers

Visual mode:

- `<leader>mb`: wrap selection in `**...**`
- `<leader>mi`: wrap selection in `*...*`
- `<leader>mc`: wrap selection in `` `...` ``
- `<leader>ml`: turn the selection into `[text]()` and place the cursor inside the URL

Normal mode:

- `<leader>m<`: increase the current heading level
- `<leader>m>`: decrease the current heading level
- `<leader>mh`: insert a horizontal rule
- `<leader>mx`: toggle a checkbox on the current line

Checkbox behaviour:

- `- [ ] item` becomes `- [x] item`
- `- [x] item` becomes `- [ ] item`
- `- item` becomes `- [ ] item`

## Plugins

Markdown support currently uses:

- `render-markdown.nvim` for inline rendering
- `markdown-preview.nvim` for browser preview, including Mermaid diagram rendering
- `nvim-treesitter` installs the `mermaid` parser for Mermaid code-fence highlighting

## Mermaid

Pure Mermaid files use the `mermaid` filetype for `.mermaid` and `.mmd` files.
Use `<leader>mm` to preview either:

- the whole current Mermaid buffer
- the Mermaid code fence containing the cursor in a Markdown buffer

## Notes

- The visual editing mappings are intended for characterwise and linewise visual selections.
- If you want a complete mapping overview beyond what the clue window shows, use `:MapTable`.
