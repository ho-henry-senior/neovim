# Neovim upstream review

Reviewed 2026-09-25 against the repository's stated goal of staying close to
stock Neovim while retaining plugins where the native feature is not yet good
enough.

## Version status

- The latest stable upstream release is **0.12.5**, published 2026-08-23. The
  installed executable is also `NVIM v0.12.5`, so no Neovim upgrade is needed.
  Source: [upstream 0.12.5 release](https://github.com/neovim/neovim/releases/tag/v0.12.5).
- The separate **nightly prerelease** is currently a 0.13 development build.
  It should not be treated as the available stable version; upstream describes
  the development branch as less predictable. Sources:
  [upstream releases](https://github.com/neovim/neovim/releases) and
  [upstream FAQ](https://github.com/neovim/neovim/wiki/FAQ#how-stable-is-the-development-pre-release-version).

## Recommended change

1. Replace `(vim.hl or vim.highlight).on_yank()` in
   `lua/config/autocmds.lua` with `vim.hl.on_yank()`. `vim.highlight` was
   renamed to `vim.hl` and is deprecated. Since this config explicitly targets
   Neovim 0.12, its compatibility fallback is no longer useful. Source:
   [upstream deprecation reference](https://neovim.io/doc/user/deprecated/#deprecated-0.11).

No other use of an API deprecated or removed in 0.12 was found. In particular,
the diagnostic jump configuration already uses the new `on_jump` form, and the
configuration uses `vim.lsp.config()` / `vim.lsp.enable()` rather than the old
`nvim-lspconfig` setup interface. Sources:
[0.12 deprecations](https://neovim.io/doc/user/deprecated/#deprecated-0.12) and
[0.12 news](https://neovim.io/doc/user/news-0.12/).

## Design review

- Keep the local `vim.pack` layer. `vim.pack` is now a built-in 0.12 feature,
  and the checked-in `nvim-pack-lock.json` follows upstream's reproducibility
  guidance. The small wrapper adds lazy triggers rather than replacing package
  management, which matches the README's design. Source:
  [upstream `vim.pack` documentation](https://neovim.io/doc/user/pack/#vim.pack).
- Keep Blink for now. Neovim 0.12 adds native automatic completion, richer LSP
  completion, popup borders, and inline completion, but switching completion
  engines would be a workflow/design choice rather than a required migration.
  Source: [0.12 completion and option changes](https://neovim.io/doc/user/news-0.12/#news-features).
- Keep the explicit LSP mappings. Neovim already provides transferable default
  mappings such as `grn`, `gra`, and `gx`; the config's additional mappings are
  actions not equivalently covered by those defaults (notably quickfix-backed
  references and fix-all). This remains consistent with the README.
- Retest the global `flags.allow_incremental_sync = false` workaround when the
  quickfix rewrite bug can be reproduced in isolation. It reduces LSP sync
  efficiency for every server, but there is not enough upstream evidence in
  the release notes to declare it obsolete, so it should not be removed merely
  because 0.12.5 is installed.
- Native `:DiffTool` and `:Undotree` are useful new stock commands, but they do
  not duplicate a configured plugin closely enough to justify removal. Source:
  [0.12 plugin features](https://neovim.io/doc/user/news-0.12/#news-features).

## Verification

- `just check` passes on Neovim 0.12.5 with the full configured plugin set.
- `stylua --check .` passes.
- `:checkhealth vim.deprecated` reports no deprecated functions detected. The
  `vim.highlight` fallback is still worth removing because the deprecated name
  is present as a dormant compatibility branch, which that runtime check does
  not exercise.
