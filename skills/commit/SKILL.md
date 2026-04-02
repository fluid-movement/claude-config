---
name: commit
description: >
  Creates git commits using conventional commit format. Stages all changed files, analyzes
  the diff to detect if changes should be split into multiple commits, and writes the commit
  message(s). Always uses conventional commit format (type: description). Trigger when the
  user says "/commit", "commit my changes", "create a commit", "make a commit", or similar.
  Always use this skill — do not do an ad-hoc commit.
---

# Commit

Stage files and create one or more conventional commits. Always run this skill in a subagent
to prevent context bloat.

---

## Instructions for Claude

**IMPORTANT:** Always delegate this entire skill to a subagent using the Agent tool.
The subagent should handle all steps below autonomously and report back with what was committed.

---

## Step 0 — Determine git workflow mode

Before doing anything else, determine whether this project uses **direct-to-main** or **GitHub flow (branch + PR)**.

### Check CLAUDE.md first

Look for a `## Git Workflow` section in the project's `CLAUDE.md` (in the current working directory — not `~/.claude/CLAUDE.md`).

- If it says something like "working directly on main" → **direct-to-main mode**
- If it says something like "GitHub flow" or "branch and PR" → **PR mode**
- If found and unambiguous: proceed silently.

### If no entry exists — detect and confirm

Run these in parallel:
- `gh api repos/{owner}/{repo}/branches/main/protection` (try `master` if `main` fails) — check for branch protection
- `gh pr list --state open --limit 5` — check for existing PRs
- `git remote -v` — check if a remote exists

Make a guess:
- Branch protection exists → guess **PR mode**
- Open PRs exist → guess **PR mode**
- No remote → guess **direct-to-main**
- Ambiguous → just ask without guessing

Ask the user to confirm, e.g.:
> "This looks like a GitHub flow project (branch protection is enabled on main). Confirm: branch + PR mode, or direct-to-main?"

Once confirmed, write the result to the project's `CLAUDE.md` — create the file if it doesn't exist, and only add this section (nothing else):

**PR mode:**
```markdown
## Git Workflow

We are using GitHub flow — commits require a branch and PR.
```

**Direct-to-main:**
```markdown
## Git Workflow

We are working directly on main.
```

---

## Step 1 — Handle branching (PR mode only)

Skip this step entirely in direct-to-main mode.

In PR mode:

- Check current branch: `git branch --show-current`
- If already on a feature branch (anything that isn't `main`, `master`, or `develop`): continue — no branch needed.
- If on `main`/`master`/`develop`: scan the diff briefly to infer the commit type and subject, then:
  - Auto-generate a branch name: `type/short-description` (kebab-case, max ~40 chars)
  - `git checkout -b <branch-name>`
  - Tell the user what branch was created after the fact.

---

## Step 2 — Gather the diff

Run in parallel:
- `git status`
- `git diff`
- `git diff --staged`

---

## Step 3 — Analyze and group changes

Group changes into logical commits:

- Single coherent unit of work → one commit
- Unrelated concerns bundled together (bug fix + new feature + docs) → split
- Refactor + the feature that required it → one commit if inseparable, otherwise split

---

## Step 4 — Draft commit messages

```
type: short imperative description
```

**Allowed types:** `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `ci`

**Rules:**
- No scope (no parentheses)
- Imperative mood, lowercase, no period, max ~72 chars

**Breaking changes:**
```
feat!: rename authenticate to verifyUser

BREAKING CHANGE: authenticate() has been renamed to verifyUser(). Update all call sites.
```

---

## Step 5 — Propose and confirm

Show the plan:

```
Proposed commits:

1. fix: correct null check in user loader
   Files: src/loaders/user.ts

2. feat: add dark mode toggle
   Files: src/components/Toolbar.svelte, src/stores/theme.ts
```

If in PR mode and a new branch was created, include it:
```
Branch: feat/add-dark-mode (created)
```

Ask: **"Proceed?"** and wait. The user may approve, reword, merge, or exclude files.

---

## Step 6 — Stage and commit

For each confirmed commit:

1. Stage files:
   - Single commit covering everything: `git add -A`
   - Split commits: `git add <file1> <file2> ...` per commit

2. Commit:
   ```bash
   git commit -m "$(cat <<'EOF'
   type: description

   BREAKING CHANGE: ... (only if applicable)
   EOF
   )"
   ```

---

## Step 7 — Offer PR creation (PR mode only)

After all commits, ask:

> "Want me to push and open a PR?"

If yes:
1. `git push -u origin <branch-name>`
2. `gh pr create --title "<commit subject>" --body "<short summary of changes>"`

If no: skip silently.

---

## Step 8 — Report back

Report:
- Number of commits created
- Each commit's short hash and message
- Branch name (if created or in PR mode)
- PR URL (if one was opened)
