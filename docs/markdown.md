# Markdown

This config treats Markdown and prose as a first-class workflow, but keeps the setup fairly small. Markdown shortcuts are listed in [keymaps.md](keymaps.md).

## Defaults

Markdown and other text-like buffers automatically:

- enable wrap
- enable spell checking
- prefer British English with fallback to English

Related filetype behaviour:

- `.txt` files are treated as Markdown
- `gitcommit` buffers get the same writing defaults

## Editing Behaviour

Checkbox toggling handles common list states:

- `- [ ] item` becomes `- [x] item`
- `- [x] item` becomes `- [ ] item`
- `- item` becomes `- [ ] item`

Link navigation follows local inline Markdown links from anywhere inside the link:

- `[label](other.md)` opens `other.md`
- `[label](other.md#some-heading)` opens `other.md` and jumps to `Some Heading`
- `[label](#some-heading)` jumps within the current Markdown file
- extensionless local links try a matching `.md` file
- external URLs are left alone; use the normal URL-opening workflow for those

The visual editing mappings are intended for characterwise and linewise visual selections.

## Plugins

Markdown support currently uses:

- `render-markdown.nvim` for inline rendering
- `markdown-preview.nvim` for browser preview, including Mermaid diagram rendering
- `nvim-treesitter` installs the `mermaid` parser for Mermaid code-fence highlighting

## Mermaid

Pure Mermaid files use the `mermaid` filetype for `.mermaid` and `.mmd` files. The Mermaid preview opens either the whole current Mermaid buffer or the Mermaid code fence containing the cursor in a Markdown buffer.
