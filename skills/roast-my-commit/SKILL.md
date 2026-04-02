---
name: roast-my-commit
description: >
  Reviews staged git changes before committing — code quality, diff hygiene, commit message,
  atomicity, and optionally verifies a specific goal or task was implemented correctly.
  Trigger when the user says "roast my commit", "review my changes before I commit", "is this
  ready to commit", or appends a goal like "roast my commit, did I implement task xyz?".
  Also trigger for "check my diff", "is my commit clean", or similar pre-commit review requests.
  Always use this skill — do not do an ad-hoc review.
---

# Roast My Commit

A pre-commit review skill. Catches code issues, diff hygiene problems, and scope drift before
they become someone else's problem. Builds on the code roast but focuses on the *change*, not
just the code in isolation.

---

## Input

### The diff
Run `git diff --staged` to get the staged changes. If nothing is staged, try `git diff HEAD` to
catch unstaged changes, and note this in the output. If the user has provided a specific commit
hash or branch, diff against that instead.

### Optional goal
The user may specify what the commit is supposed to accomplish:
- *"roast my commit, did I implement task xyz?"*
- *"roast my commit, this should fix the pagination bug"*
- *"roast my commit — ticket #234"*

If a ticket reference is given and a GitHub/Linear/Jira MCP is available, look it up silently
and use the acceptance criteria as the verification target.

### Context gathering (opportunistic, silent)
Before running the roast, check for any of the following — use what's there, don't mention
what isn't:
- `CLAUDE.md`, `README.md`, `SPEC.md`, `ARCHITECTURE.md` — project conventions, stated patterns
- Open files / recent conversation context — what problem were we solving?
- Existing code patterns in touched files — what's the established approach?

If the user requested scope verification (via an explicit goal or task) and *none* of the above
is available, ask one targeted question before proceeding: *"What's the goal of this change?"*
For a bare `roast my commit` with no goal, skip the question entirely.

---

## Output Format

Start with a one-line **verdict** on the commit as a whole.

If a goal was provided, add a **🎯 Goal: [their question/task]** section immediately after,
with a clear verdict: *Implemented / Partially implemented / Not implemented / Can't tell* —
plus specific evidence from the diff.

Then the commit-specific criteria (only include sections with something worth saying — skip
criteria that are clean):

```
### [Emoji] Criterion — [Good / Acceptable / Needs Work / Yikes]

[2–5 sentences. Specific, actionable, evidence-based.]
```

End with a **Bottom Line**: 2–4 sentences, most important issues first.

---

## Commit-Specific Criteria

Assess all of these, surface only the ones with findings.

### 📦 Atomicity
Is this one coherent, logical change? Or is it three things bundled together because they
happened at the same time? A good commit should be possible to describe in one sentence without
using "and". Flag mixed concerns, unrelated fixes bundled in, or work-in-progress fragments.

### 💬 Commit Message
If the user has drafted a message (check for it in context or ask if unclear):
- Does the subject line accurately describe what changed?
- Is it specific enough to be useful in a log? ("fix bug" is not.)
- Imperative mood in subject line (`Add X`, not `Added X` or `Adding X`)
- Is a body needed and absent, or present and redundant?

If no message has been drafted yet, note it in the Bottom Line.

### 🧹 Diff Hygiene
Look for things that shouldn't be in a commit:
- Debug statements, `console.log`, `var_dump`, `fmt.Println` left in
- Commented-out code with no explanation
- Unintended files (`.env`, build artifacts, editor config that shouldn't be shared)
- Whitespace-only changes mixed in with real changes
- TODO comments that were added but reference work not included in this commit

### 📐 Scope vs. Project Conventions
Cross-reference the diff against gathered context (CLAUDE.md, README, existing patterns):
- Does this introduce a new pattern where an established one exists?
- Does it contradict documented architectural decisions?
- Does it touch areas unrelated to the stated goal?
- Is it consistent with how similar problems are solved elsewhere in the codebase?

This criterion is skipped silently if no useful context was found and no goal was specified.

### 🧪 Test Coverage
Does the diff include tests for new behaviour? Flag:
- New functions/methods with no corresponding tests added
- Bug fixes with no regression test
- Tests that were clearly not updated to reflect changed behaviour

Don't penalise test-only commits or changes to non-testable code (config, migrations, etc.).

### 📏 Size
Is this commit a reasonable unit of work?
- **Too large**: multiple screens of diff, touches unrelated subsystems, hard to review
- **Too small**: single typo fix mixed with a feature, suggests it should have been squashed
  or that related work is missing

Only flag size if it's genuinely a problem — most commits are fine.

---

## Code Quality

After the commit-specific criteria, run the **roast-my-code** skill on the changed files
(not the whole codebase — just what's in the diff). This catches code-level issues in the
actual changes. Label this section clearly:

```
---
## Code Quality (changed files)
[roast-my-code output for the diff, criteria as usual]
```

---

## Tone Guide

Same as roast-my-code: matter-of-fact, a hint of wit, specific and actionable. One observation
per section at most. The goal is a clean commit, not a comedy bit.
