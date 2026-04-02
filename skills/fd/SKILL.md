---
name: fd
description: >
  Reference guide for fd, a modern find replacement. Use when running Bash commands
  that need to find files — especially in pipelines with -exec, xargs, or when
  chaining with other tools. Always call `fd` explicitly — never `find`.
  Note: prefer the Glob tool for simple file pattern matching. Use fd when Glob
  is insufficient (e.g. exec pipelines, type filtering, date filtering, exclusions).
---

# fd

`fd` replaces `find` in Bash pipelines. Call it by name — never use `find`.

Use the `Glob` tool for simple file pattern matching. Use `fd` for pipelines, exec, and advanced filtering.

---

## Common patterns

```bash
fd <pattern>                    # Find by name (smart case, regex-friendly)
fd -e ts                        # Find by extension
fd -t f                         # Files only (-t d for dirs, -t l for symlinks)
fd --hidden                     # Include hidden files/dirs
fd -E node_modules <pattern>    # Exclude a directory
fd -e json --exec bat           # Find files, run command on each
fd --changed-within 1d          # Modified in the last day
fd --changed-before 1w          # Modified more than a week ago
fd -t f -e ts | xargs rg 'TODO' # Find TS files, search content in them
```

---

## Key flags

```
-e / --extension EXT   Filter by file extension (no dot needed)
-t / --type TYPE       f=file, d=directory, l=symlink, x=executable, e=empty
-H / --hidden          Include hidden files and directories
-I / --no-ignore       Don't respect .gitignore/.fdignore
-E / --exclude GLOB    Exclude files/dirs matching pattern
--changed-within TIME  Files modified within TIME (1d, 2h, 30min, etc.)
--changed-before TIME  Files modified before TIME
--max-depth N          Limit search depth
-x / --exec CMD        Execute command for each result (parallel)
-X / --exec-batch CMD  Execute command with all results as arguments
-0 / --print0          Null-separated output (for xargs -0)
-l / --list-details    Long listing (like ls -l)
```

---

## Examples

```bash
# Find all TypeScript files, excluding node_modules and dist
fd -e ts -E node_modules -E dist

# Find recently changed files
fd --changed-within 2d -t f

# Find and preview JSON configs
fd -e json -t f --exec bat {}

# Find large files (pipe to eza for details)
fd -t f | xargs eza -la

# Search content only in source files
fd -e ts -e svelte -t f -0 | xargs -0 rg 'pattern'
```
