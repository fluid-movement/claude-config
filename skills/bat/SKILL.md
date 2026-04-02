---
name: bat
description: >
  Reference guide for bat, a modern cat replacement with syntax highlighting. Use
  when displaying file contents to the user via Bash commands. Always call `bat`
  explicitly — never `cat`, `head`, or `tail`. Note: prefer the Read tool for
  Claude's internal file reading. Use bat when the goal is to show content to the
  user in the terminal with highlighting and context.
---

# bat

`bat` replaces `cat`/`head`/`tail` in Bash output to the user. Call it by name — never use `cat`.

Use the `Read` tool for Claude's own file reading. Use `bat` when showing content visually.

---

## Common patterns

```bash
bat <file>                      # Syntax-highlighted with line numbers and git changes
bat --plain <file>              # No decorations — clean for piping
bat -r 1:50 <file>              # Show lines 1–50 only
bat -r 100: <file>              # From line 100 to end
bat -l json <file>              # Force language (auto-detected by extension)
bat --style=numbers <file>      # Line numbers only, no git/header decorations
bat --style=header,numbers,grid # Custom style combination
```

---

## Key flags

```
--plain / -p          No line numbers, no pager, no decoration
-r / --line-range     LINE:LINE range to display
-l / --language       Force syntax language
--style=COMPONENTS    Comma-separated: auto, full, plain, changes, header,
                      header-filename, header-filesize, grid, rule, numbers, snip
--pager=never         Disable paging (output all at once)
--color=always        Force color (useful when piping to less/other tools)
```

---

## Examples

```bash
# Preview a config file cleanly
bat config.json

# Show only a relevant section
bat -r 10:40 src/index.ts

# Cat-style output for piping (no decoration)
bat --plain --pager=never src/utils.ts | rg 'TODO'

# Show multiple files
bat src/a.ts src/b.ts
```
