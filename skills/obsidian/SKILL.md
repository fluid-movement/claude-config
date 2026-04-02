---
name: obsidian
description: >
  General-purpose Obsidian vault skill using the obsidian CLI. Use when the user wants to
  read, write, edit, search, or manage files in their Obsidian vault. Trigger phrases include
  "read my obsidian note", "read obsidian file", "open this note in obsidian",
  "write to obsidian", "update my vault", "edit obsidian file", "create a note",
  "add to my obsidian note", "append to obsidian", "search obsidian", "find in my vault",
  "list my notes", "what's in my vault", "use the obsidian CLI", "obsidian read", "obsidian write".
  Also trigger when the user provides a vault path and wants Claude to interact with it.
version: 0.1.0
---

# Obsidian CLI

Read, write, and manage files in the user's Obsidian vault using the `obsidian` CLI.

## Prerequisites

- Obsidian must be running. Check first:
  ```bash
  pgrep -x "Obsidian" > /dev/null 2>&1 && echo "running" || echo "not running"
  ```
  If not running, ask the user to open Obsidian before continuing.
- CLI must be enabled: Obsidian → Settings → General → Command line interface

## Path vs Name

- `path=` — exact path relative to vault root (e.g. `path="folder/note.md"`)
- `file=` — resolves by name like a wikilink (e.g. `file="My Note"`)

Use `path=` when the user gives you a specific path. Use `file=` when they give you a note name.

---

## Core Operations

### Read a file
```bash
obsidian read path="folder/note.md"
obsidian read file="Note Name"
```

### Create or overwrite a file
```bash
# Single-line content
obsidian create path="folder/note.md" content="Hello world" open

# Multi-line content — write to temp file first, then use awk to convert newlines
cat > /tmp/obs_content.md << 'EOF'
# My Note

Content goes here.
EOF
obsidian create path="folder/note.md" content="$(awk '{printf "%s\\n", $0}' /tmp/obs_content.md)" open

# Overwrite if file already exists
obsidian create path="folder/note.md" content="..." overwrite
```

### Append to a file
```bash
obsidian append path="folder/note.md" content="New line to add"
# Append inline (no leading newline)
obsidian append path="folder/note.md" content="..." inline
```

### Prepend to a file
```bash
obsidian prepend path="folder/note.md" content="Text at the top"
```

### Delete a file
```bash
obsidian delete path="folder/note.md"           # Moves to trash
obsidian delete path="folder/note.md" permanent  # Permanent delete
```

### Rename or move a file
```bash
obsidian rename path="folder/old.md" name="New Name"
obsidian move path="folder/note.md" to="other-folder"
```

---

## Search & Discovery

### Search vault content
```bash
obsidian search query="search term"
obsidian search query="term" path="folder"      # Limit to folder
obsidian search query="term" limit=10           # Cap results
obsidian search query="term" format=json        # JSON output
obsidian search:context query="term"            # Show surrounding context
```

### List files and folders
```bash
obsidian files                                  # All files
obsidian files folder="folder/path"             # Files in a folder
obsidian files ext=md                           # Filter by extension
obsidian folders                                # All folders
```

### Recently opened
```bash
obsidian recents
```

---

## Metadata & Properties (YAML Frontmatter)

### Read all properties for a file
```bash
obsidian properties path="folder/note.md"
obsidian properties path="folder/note.md" format=json
```

### Read a specific property
```bash
obsidian property:read name="tags" path="folder/note.md"
```

### Set a property
```bash
obsidian property:set name="status" value="done" path="folder/note.md"
obsidian property:set name="priority" value="1" type=number path="folder/note.md"
# type options: text | list | number | checkbox | date | datetime
```

### Remove a property
```bash
obsidian property:remove name="status" path="folder/note.md"
```

---

## Links & Graph

```bash
obsidian links path="folder/note.md"            # Outgoing links
obsidian backlinks path="folder/note.md"        # Incoming links
obsidian orphans                                # Files with no backlinks
obsidian deadends                               # Files with no outgoing links
```

---

## Tags & Tasks

```bash
obsidian tags                                   # All tags in vault
obsidian tags path="folder/note.md"             # Tags in a file
obsidian tasks                                  # All tasks
obsidian tasks path="folder/note.md" todo       # Incomplete tasks in file
obsidian tasks done                             # Completed tasks
```

---

## Vault Info

```bash
obsidian vault                                  # Full vault info
obsidian vault info=name                        # Vault name only
obsidian vault info=path                        # Vault path only
obsidian vaults                                 # All vaults
```

---

## Quick Reference

| Goal | Command |
|------|---------|
| Read file | `obsidian read path="folder/note.md"` |
| Create note | `obsidian create path="folder/note.md" content="..." open` |
| Overwrite note | `obsidian create path="folder/note.md" content="..." overwrite` |
| Append text | `obsidian append path="folder/note.md" content="..."` |
| Search vault | `obsidian search query="text"` |
| List files | `obsidian files folder="path"` |
| Get tags | `obsidian tags path="folder/note.md"` |
| Read property | `obsidian property:read name="key" path="..."` |
| Set property | `obsidian property:set name="key" value="val" path="..."` |
| Vault path | `obsidian vault info=path` |

## Multi-line Content

The CLI requires `\n` literals in `content=` strings. For any multi-line content, write to a temp file and convert with `awk`:

```bash
cat > /tmp/obs_content.md << 'EOF'
[your content here]
EOF
obsidian create path="target/note.md" content="$(awk '{printf "%s\\n", $0}' /tmp/obs_content.md)"
```
