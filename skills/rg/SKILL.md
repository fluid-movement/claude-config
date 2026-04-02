---
name: rg
description: >
  Reference guide for rg (ripgrep), a modern grep replacement. Use when running
  Bash commands that search file content — especially in pipelines or when the
  built-in Grep tool is insufficient (e.g. complex piped workflows, output formatting,
  or combining with fd/bat). Always call `rg` explicitly — never `grep`.
  Note: prefer the built-in Grep tool for direct content searches. Use rg in Bash
  when you need piping, xargs integration, or output control not available in Grep.
---

# rg (ripgrep)

`rg` replaces `grep` in Bash pipelines. Call it by name — never use `grep`.

Use the `Grep` tool for direct content searches. Use `rg` in Bash when you need pipelines,
xargs integration, or output formatting the Grep tool can't provide.

---

## Common patterns

```bash
rg <pattern>                    # Search current directory recursively
rg -t ts <pattern>              # Search only TypeScript files
rg -l <pattern>                 # Filenames only (no content lines)
rg -c <pattern>                 # Match counts per file
rg --hidden <pattern>           # Include hidden files/dirs
rg -i <pattern>                 # Case-insensitive
rg -A 3 -B 3 <pattern>          # 3 lines context around each match
rg -e 'pattern1' -e 'pattern2'  # Multiple patterns (OR)
```

---

## Key flags

```
-t / --type TYPE       File type filter: ts, js, py, rust, go, json, yaml, etc.
-T / --type-not TYPE   Exclude file type
-l / --files-with-matches   Filenames only
-L / --files-without-match  Files with no match
-c / --count           Match count per file
-i / --ignore-case     Case-insensitive
-s / --case-sensitive  Force case-sensitive
-w / --word-regexp     Match whole words only
-x / --line-regexp     Match whole lines only
-v / --invert-match    Lines that don't match
-A N / --after-context  N lines after each match
-B N / --before-context N lines before each match
-C N / --context        N lines before and after
-n / --line-number     Show line numbers (default)
-N / --no-line-number  Suppress line numbers
--no-filename          Suppress filenames
-H / --with-filename   Always show filenames
--hidden               Search hidden files/dirs
-I / --no-ignore       Don't respect .gitignore
-g GLOB / --glob GLOB  Include/exclude by glob (prefix ! to exclude)
-e PATTERN             Additional pattern (for multiple)
-0 / --null            Null-separated output (for xargs -0)
--json                 Output as JSON
```

---

## File type shortcuts

```bash
rg -t ts        # TypeScript
rg -t js        # JavaScript
rg -t py        # Python
rg -t rust      # Rust
rg -t go        # Go
rg -t json      # JSON
rg -t yaml      # YAML / yml
rg -t md        # Markdown
```

Run `rg --type-list` to see all supported types.

---

## Examples

```bash
# Find TODO/FIXME across source files only
rg -t ts -t svelte 'TODO|FIXME'

# Find files importing a specific module
rg -l "from '@/lib/utils'"

# Search with context, case-insensitive
rg -i -C 3 'error handling'

# Exclude node_modules/dist and search
rg --glob '!node_modules' --glob '!dist' 'pattern'

# Pipe filenames to bat for preview
rg -l 'useEffect' | xargs bat --style=header

# Count matches per file, sorted
rg -c 'console.log' | sort -t: -k2 -rn
```
