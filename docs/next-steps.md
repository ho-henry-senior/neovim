# Neovim Config Next Steps

These notes summarize follow-up ideas from reviewing the config against its
current design goals:

- stay close to stock Neovim
- prefer native editor primitives before adding plugins
- keep leader mappings for frequent or clearer workflows
- make quickfix, diagnostics, sessions, and LSP feel intentional rather than noisy

## Strong Candidates

### 1. Keep improving quickfix ergonomics

Quickfix is already a central workflow in this config. The recent `[q` / `]q`
change is a good direction: navigation now treats list boundaries as expected
states instead of surfacing raw Vim errors.

Possible follow-ups:

- keep boundary notifications for beginning/end of results
- notify when the quickfix list is empty
- avoid opening quickfix windows for empty result sets
- use consistent titles for quickfix lists populated by diagnostics, references,
  git, tests, search, and AI workflows

### 2. Add a small quickfix helper

Several features populate quickfix:

- diagnostics
- LSP references
- git diff files
- git hunks
- failed tests
- search/replace results
- CopilotChat results

A small helper could centralize common behavior:

- replace the quickfix list
- open it only when non-empty
- notify when there are no results
- apply a consistent title

This keeps the workflow native while making it feel more polished.

### 3. Add quickfix open/close mappings

Consider adding direct mappings under the existing `<leader>q` group:

| Mapping | Action |
| --- | --- |
| `<leader>qo` | Open quickfix |
| `<leader>qc` | Close quickfix |

These are simple native commands, but the mappings would make the quickfix
workflow easier to discover.

### 4. Document quickfix boundary behavior

Update `docs/workflows.md` or `docs/motions.md` to mention that `[q` and `]q`
notify at the beginning/end of the list.

This makes the new behavior intentional and discoverable.

## Optional Candidates

### 5. Consider quickfix history mappings

Native quickfix has history via `:colder` and `:cnewer`. If quickfix becomes
the main place for diagnostics, grep, git, and test results, quickfix history
could be useful.

Possible mappings:

| Mapping | Action |
| --- | --- |
| `<leader>qp` | Previous quickfix list (`:colder`) |
| `<leader>qn` | Next quickfix list (`:cnewer`) |

This is worth adding only if switching between previous quickfix result sets is
something that would actually be used.

### 6. Add diagnostic boundary notifications

Diagnostic motions already use native-style bracket mappings:

- `[d` / `]d`
- `[e` / `]e`
- `[w` / `]w`

If those ever feel noisy at boundaries, mirror the quickfix behavior with
friendly notifications instead of raw navigation errors.

## Location Lists

Location lists are the window-local sibling of quickfix lists:

- quickfix is shared across the current editor/tab workflow
- location lists are scoped per window

They are useful when different windows should keep different result sets. For
example, one split could hold diagnostics while another split keeps grep
results or references.

That does not sound like the current workflow. If quickfix is the single global
"task list" for diagnostics, grep results, references, failed tests, git hunks,
and AI output, then quickfix is the better fit.

Do not add location-list mappings just for completeness. Consider `[l` / `]l`
only if a real window-local workflow appears.

## Things To Avoid

These would likely work against the current design goals:

- adding a dashboard
- adding another fuzzy finder
- adding a large keymap abstraction layer
- replacing native quickfix/location-list workflows with plugin-only flows
- enabling visual effects such as animated scrolling without a clear need
- adding location-list mappings before there is a real location-list workflow
