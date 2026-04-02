---
name: eza
description: >
  Reference guide for eza, a modern ls replacement. MUST be used proactively whenever
  running Bash commands that list directory contents, show project structure, explore
  file trees, or inspect file metadata. Always call `eza` explicitly — never `ls`.
  Trigger contexts: listing files, showing a directory, tree view, project overview,
  checking file sizes/permissions/timestamps, git-aware directory listing.
---

# eza

`eza` is the modern replacement for `ls`. Always call it by name — never use `ls`.

---

## Common patterns

| Goal | Command |
|------|---------|
| Standard listing (all, long) | `eza -la` |
| With git status | `eza -la --git` |
| Tree view, 2 levels | `eza -T -L 2` |
| Tree with git + icons | `eza -T -L 3 --git --icons` |
| Sorted by modification time | `eza -la --sort=modified` |
| Directory sizes (recursive) | `eza -la --total-size` |
| Directories only | `eza -laD` |
| Files only | `eza -laf` |
| With column headers | `eza -la --header` |

---

## Key flags

```
-l / --long          Extended metadata table
-a / --all           Include hidden/dot files
-T / --tree          Recursive tree view
-L / --level=N       Limit recursion depth
-D / --only-dirs     Directories only
-f / --only-files    Files only
-r / --reverse       Reverse sort order
-s / --sort=FIELD    Sort by: name, size, modified, created, type, extension, inode
--git                Git status per file (staged/unstaged columns)
--git-repos          Git status per directory
--icons              File type icons
--total-size         Recursive sizes for directories
--group-directories-first
--header             Column headers
--octal-permissions  Permissions in octal
--inode              Inode numbers
--time-style=STYLE   Timestamp: default, iso, long-iso, full-iso, relative
-b / --binary        Binary size prefixes (KiB, MiB)
-B / --bytes         Raw byte counts
```

---

## Git status columns (with `--git`)

When `--git` is used in a repo, two extra columns appear: staged and unstaged status.

| Symbol | Meaning |
|--------|---------|
| `-` | Unmodified |
| `M` | Modified |
| `N` | New / untracked |
| `D` | Deleted |
| `R` | Renamed |
| `I` | Ignored |
| `U` | Conflicted |

---

## Examples

```bash
# Quick project overview
eza -T -L 2 --git --icons

# Recently modified files (newest first)
eza -la --sort=modified --reverse

# Check directory sizes at root
eza -laD --total-size

# Full metadata: permissions, inode, git, headers
eza -la --git --inode --header --octal-permissions

# Explore deeply with 4 levels
eza -T -L 4 --git

# Show only files modified recently
eza -la --sort=modified -f
```
