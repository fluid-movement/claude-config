---
name: obsidian-save
description: This skill should be used when the user wants to save a conversation or part of a conversation to their Obsidian vault, or when they want Claude to research a topic and save the findings as an Obsidian note. Trigger phrases include "save to Obsidian", "save this conversation to Obsidian", "save this to my vault", "export to Obsidian", "save our chat to Obsidian", "add this to my notes", "log this to Obsidian", "save this conversation", "save this part of the conversation to Obsidian", "do research on X and save to Obsidian", "research X and create an Obsidian note", "create a note on X".
version: 0.2.0
---

# Save to Obsidian

Save a structured note to the user's Obsidian vault using the Obsidian CLI. Supports two modes: summarizing a conversation, or researching a topic and saving the findings.

## Prerequisites

- Obsidian must be installed (the skill will launch it if not running and wait for it to be ready)
- CLI must be enabled: Obsidian → Settings → General → Command line interface

## Content Mode

### Mode A — Conversation Save

**Triggered by:** "save this conversation", "save this part about X", "export our chat", etc.

**Content:** Summarize the conversation (full or scoped to the requested portion). Capture what was discussed, decisions made, and key takeaways.

### Mode B — Research Note

**Triggered by:** "research X and save to Obsidian", "do research on X and save to Obsidian", "create a note on X", "research X and create an Obsidian note", etc.

**Content:** Perform the research first (web search, codebase exploration, or both), then format findings into the note structure below. Complete all research before drafting note content.

## Output Format

Notes must follow this exact structure:

```markdown
---
date: "YYYY-MM-DD"
tags:
  - claude-summary
  - [topic-tag]
---
# [Descriptive Title]

## Overview

[2-4 sentence summary of what was discussed and any decisions/outcomes]

## Key Discussion Points

### [Subtopic 1]
- bullet points of key facts, concepts, or exchanges

### [Subtopic 2]
- ...

## Solutions/Decisions

[What was decided, recommended, or resolved. Include code blocks if relevant.]

## Key Takeaways

1. **Takeaway**: explanation
2. ...

## Next Steps

- [ ] action items if any
```

Adapt sections to the content — not all sections are required for every note. For a shorter or more focused topic, fewer sections are fine.

## Workflow

### 1. Determine mode

Determine whether the user wants a conversation summary (Mode A) or a research note (Mode B). For Mode B, complete the research first before drafting note content.

### 2. Generate content

**Mode A:** Write a concise, structured summary. The goal is a useful reference note — not a verbatim transcript. Capture:
- What problem or topic was discussed
- Key facts, concepts, and options explored
- What was decided or recommended
- Takeaways and next steps

**Mode B:** Perform research using web search and/or codebase exploration. Synthesize findings into clear, well-organized content covering the topic thoroughly.

### 3. Determine note title and tags

- **Title**: descriptive, topic-based (e.g., "Git Branching Strategies and Hierarchical Branch Limitations")
- **Tags**: always include `claude-summary`, plus 1-2 topic tags (e.g., `git`, `learning`, `typescript`)
- **Date**: today's date in `"YYYY-MM-DD"` format (quoted string)

### 4. Save to vault

Default save location: `claude/` folder in the vault.

**Before saving**, check whether Obsidian is running:

```bash
pgrep -x "Obsidian" > /dev/null 2>&1 && echo "running" || echo "not running"
```

If it is **not running**, stop and ask the user to open Obsidian, then wait for them to confirm it is open before continuing. Do not attempt to launch it automatically — `open -a Obsidian && sleep` is unreliable.

Once Obsidian is confirmed running, write the note content to a temp file and use the Obsidian CLI:

```bash
# 1. Write note to temp file
cat > /tmp/obsidian_note.md << 'OBSIDIAN_EOF'
[formatted note content here]
OBSIDIAN_EOF

# 2. Check if Obsidian is running — if not, stop and ask the user to open it
pgrep -x "Obsidian" > /dev/null 2>&1

# 3. Save the note
obsidian create path="claude/[Title]" content="$(awk '{printf "%s\\n", $0}' /tmp/obsidian_note.md)" open
```

### 5. Confirm

Report the note title and that it was saved to the `claude/` folder.

## CLI Quick Reference

| Goal | Command |
|------|---------|
| Create note | `obsidian create path="claude/Title" content="..." open` |
| Overwrite existing | `obsidian create path="claude/Title" content="..." overwrite` |
| Append to note | `obsidian append file="Title" content="..."` |
| Create and open | `obsidian create path="claude/Title" content="..." open` |

The CLI requires `\n` literals for newlines in the content string — use the `awk` approach above to handle this correctly.
