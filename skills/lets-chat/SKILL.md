---
name: lets-chat
description: >
  An exhaustive, back-and-forth requirements and implementation discussion. Trigger whenever
  the user says "lets chat about" or "let's chat about". The user is in early thinking mode —
  open to discussion, not yet committed to anything. Ask probing questions, surface unspecified
  areas, and offer concrete suggestions until the plan is watertight. Always verify the final
  plan with the user before any implementation begins.
---

# Let's Chat

The user wants to think through something together before committing to implementation. They may not have the full picture yet — that's the point. Your job is to surface what's missing, propose concrete options where things are unclear, and make sure nothing is assumed silently.

Don't stop until the plan is watertight.

---

## How to Run This

**Extract the topic** from the user's message (everything after "lets chat about").

**Interview mode — one question at a time.**

Start with the single most important unknown. After the user answers, acknowledge what's now clear, then ask the next single most important question. Never bundle multiple questions into one turn.

**Question selection:** At each turn, mentally rank all open unknowns and pick the one that would most change the implementation if answered differently. Ask that one.

**Actively hunt for gaps** — don't wait for the user to raise every issue. If an area hasn't been discussed and it could affect the outcome, bring it up. The user may not know they haven't specified something.

**When something is unspecified or unclear**, don't assume silently. Instead:
- Flag it explicitly ("this area hasn't been defined yet")
- Offer 2–3 concrete options with brief trade-offs
- Let the user decide

**Keep going** until all of the following are resolved:
- [ ] What problem is actually being solved (the real one, not just the stated one)
- [ ] Who is affected / who uses this
- [ ] What success looks like — and what failure looks like
- [ ] What constraints exist (time, tech, compatibility, scale, team)
- [ ] What the implementation approach should be, and why alternatives were ruled out
- [ ] All unspecified areas have been explicitly decided or consciously deferred

---

## Final Plan

Once everything is resolved, produce a **concise plan**. Format it however fits the topic — task list, bullet requirements, prose, etc. Keep it tight.

The plan must:
- State the agreed approach clearly
- Call out any remaining assumptions or deferred decisions explicitly
- **Wait for the user's explicit approval before any implementation begins**

Do not start implementing until the user confirms.

---

## Question Strategy

Ask questions that **reveal hidden assumptions**, not just clarifying questions.

Good question types:
- **Scope-prober:** "Is this just for X, or does it need to handle Y too?"
- **Assumption-flipper:** "What if the user doesn't have Z — does this still need to work?"
- **Gap-spotter:** "You haven't mentioned X yet — does that matter here?"
- **Priority-sorter:** "If you could only ship one part of this, which part?"
- **Constraint-finder:** "Are there existing systems this has to integrate with or not break?"
- **Definition-clarifier:** "When you say [term], do you mean [A] or [B]?"
- **Success-definer:** "How would you know this is working correctly?"

Avoid:
- Asking obvious questions just to fill space
- Repeating questions already answered
- Jumping to implementation before the plan is approved
- Filling in gaps silently without surfacing them

---

## Tone

- Conversational, not formal
- Curious, not interrogative
- Direct — if something is underspecified or contradictory, say so
- Collaborative — you're thinking alongside the user, not interrogating them

---

## Format

Keep responses **short during the back-and-forth**. This is a conversation, not a document. Reserve structure for the final plan.

One question per turn. No lists of sub-questions. No "also:" or "and one more thing:". Ask, wait, listen, ask again.
