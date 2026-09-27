# Just

The local Just integration discovers the nearest ancestor justfile from the current file's directory. For unnamed or special buffers, discovery begins at the current window's working directory.

Use `<leader>j` or `:Just` to select a public recipe. Recipe documentation appears beside its name when available. Use `:Just recipe arg…` to run a recipe directly; recipe-name completion is available for the first argument.

Recipe output streams into a reusable 12-line bottom split. When the process exits, output that matches Neovim's current `errorformat` is placed in quickfix and quickfix opens. The output buffer retains the complete transcript. Starting another recipe while one is active prompts before stopping it.

The initial implementation is intended for root-level, non-parameterised, non-interactive recipes.

## Future Ideas

- Prompt for recipe parameters, using defaults from Just's JSON metadata.
- Run interactive recipes in a terminal-capable output window.
- Make the output layout configurable, including a floating-window option.
