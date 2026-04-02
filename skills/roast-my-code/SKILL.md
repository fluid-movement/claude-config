---
name: roast-my-code
description: >
  Performs a thorough, criterion-by-criterion code review with a matter-of-fact tone and a hint of wit.
  Trigger whenever the user says "roast my code", "roast this", "roast [filename/folder]", or asks for a
  code roast. Also trigger if the user asks to "tear apart", "critique", or "brutally review" their code.
  The input can be: code already in context, a file path, or a folder path. Always use this skill — do
  not just do an ad-hoc review.
---

# Roast My Code

A structured code review skill. The goal is to be genuinely useful: honest, specific, and actionable.
The tone is matter-of-fact with a hint of wit — not a comedy routine, not a rubber-stamp.

---

## Input

The code to roast comes from one of:
- **Code already in context** — from earlier in the conversation
- **A file path** — read it with the appropriate tool
- **A folder path** — scan the structure, read relevant files (focus on source files, skip lock files / generated code / vendored deps)

If it's a folder, get a feel for the overall structure first, then roast the most meaningful files. Call out architectural issues at the folder level if relevant.

Note the **language** before starting — all style, idiom, and necessity judgments are language-specific.

### Optional Focus Hint

The user may append a specific question or concern, e.g. *"roast my code, did I bork the project structure?"*. If so:
- Still run the full roast as normal
- Add a dedicated **🎯 Focus: [their question]** section at the top of the output, directly after the verdict line
- Answer it specifically, with evidence from the code
- The rest of the roast continues as usual — the focus hint doesn't replace it, it adds to it

---

## Output Format

Start with a one-line **verdict** — a punchy, honest summary of the overall state of the code.

Then go through each criterion. Use this structure for each:

```
### [Emoji] Criterion Name — [Verdict: Good / Acceptable / Needs Work / Yikes]

[2–5 sentences of honest assessment. Be specific — quote or reference actual code.
If something is good, say so. If it's bad, say why and what to do instead.]
```

End with a **Bottom Line** section: 2–4 sentences summarizing the most important things to fix, in priority order.

---

## Criteria

Assess all eight internally. **Only include a section in the output if there's something worth saying** — a real finding, a genuine compliment, or a notable absence. If error handling is fine, don't mention it. If security is excellent and worth calling out, do. The goal is signal, not completeness theater.

If fewer than three criteria have findings, something's either very good or very bad — the verdict line should reflect that.

### 1. ✅ Function
Does the code actually do what it's supposed to do? Look for logic errors, off-by-one issues, incorrect assumptions, unhandled edge cases that would cause wrong results or crashes. If you can't fully verify correctness without running it, say so — but flag anything that looks suspect.

### 2. 🎨 Style
Is the code idiomatic for its language? Would a senior developer in this ecosystem recognize this as natural code, or does it feel like it was written by someone thinking in a different language? Flag naming conventions, patterns, and idioms that are off.

### 3. 📖 Readability
Is this easy to understand? Consider: variable/function naming, comment quality (too many, too few, stating the obvious), function length, nesting depth, cognitive load. Good code should read roughly like prose.

### 4. 🔧 Necessity
Is this solving a problem the language/stdlib/ecosystem already solves? Flag reinvented wheels, hand-rolled utilities that exist in the standard library, or overengineered solutions to simple problems. Also flag the inverse: using a heavy dependency for something trivial.

### 5. ⚠️ Error Handling
Are errors and edge cases handled correctly and idiomatically for this language? Flag silent failures, swallowed errors, missing boundary checks, or anything that would leave the caller with no idea something went wrong.

### 6. 🧪 Testability
Is this code structured in a way that makes it easy to test? Look for: tight coupling, hidden dependencies, global state, functions that do too many things. You don't need to write tests — just assess whether writing them would be painful.

### 7. 🔒 Security
Any obvious vulnerabilities? SQL injection, unsanitized input, hardcoded secrets, overly broad permissions, unsafe deserialization, etc. Be language- and context-aware — a CLI tool and a web endpoint have different threat models.

### 8. ⚡ Performance
Any glaring inefficiencies? N+1 queries, unnecessary allocations in hot paths, missing indexes implied by the code, O(n²) where O(n) is easy. Don't nitpick micro-optimizations — flag things that actually matter.

---

## Tone Guide

- **Be specific.** "This is bad" is useless. "This loop re-queries the database on every iteration" is useful.
- **Be direct.** Don't bury the lede in qualifications.
- **Be fair.** If something is genuinely well done, say so. A roast that praises nothing is just noise.
- **Wit is a seasoning, not the main course.** One dry observation per section at most. The value is in the analysis.
- **No moralizing.** Say the thing once, clearly. Don't repeat it.

---

## Example Verdict Line

> "Structurally sound, but this code has never met an error it didn't ignore."

> "This works, and someone clearly knows the language — but the test coverage is theoretical at best."

> "Readable, idiomatic code. The security section is where the fun starts."