---
runbook: true
---
# {{TITLE}} [AWAITING REVIEW]

<!-- Meta: one "**Label:** value \" line per field. Updated: append "YYYY-MM-DD — what changed." entries on that line, oldest first. -->
> **Related:** {{RELATED_DOCS_OR_DASH}} \
> **Context:** {{ONE_LINE_CONTEXT}} \
> **Purpose:** {{WHY_THIS_DOC_EXISTS}} \
> **Scope:** {{WHAT_IS_IN_AND_OUT_OF_SCOPE}} \
> **Created:** {{DATE}} \
> **Updated:** —

## Verdict

**{{HEADLINE_VERDICT_ONE_OR_TWO_SENTENCES}}**

## Locked decisions

| Decision | Choice | Why |
|---|---|---|
| {{DECISION}} | {{CHOICE}} | {{WHY}} |

## Summary

<!-- Effort column is OPTIONAL: drop it for feasibility docs. -->
| # | Item | Risk | Status | Effort | One-line verdict |
|---|---|---|---|---|---|
| 1 | [{{ITEM_TITLE}}](#item-1) | [MED] | [PENDING] | {{EFFORT_e.g_~5_min}} | {{ONE_LINE_VERDICT}} |

## Glossary

Every service/tool named in this doc, and every acronym expanded — read this first if any name is unfamiliar.

| Service / tool | What it is | Role in this plan |
|---|---|---|
| **{{SERVICE_OR_TOOL}}** | {{WHAT_IT_IS_IN_PLAIN_LANGUAGE}} | {{ROLE_IN_THIS_PLAN}} |

| Acronym | Full form | Meaning here |
|---|---|---|
| **{{ACRONYM}}** | {{FULL_FORM}} | {{WHAT_IT_MEANS_IN_THIS_DOC}} |

## Items

<!-- One "### N. Title [RISK] [STATUS]" per item; everything until the next ### or ## is its collapsible Brief.
     To group items, an unnumbered "### Phase 1 — Rollout" between them is a group label, not an item.
     Keep the labels that apply (1–3 sentences each), delete the rest. Back factual claims with the command that proved them.
     Later, end an item with its own note paragraph: *Completed: YYYY-MM-DD — what happened.*
     (also *Correction YYYY-MM-DD: originally X; actually Y.* · *Blocked: YYYY-MM-DD — what it waits on.*) -->

### 1. {{ITEM_TITLE}} [MED] [PENDING]

**What's involved:** {{WHAT}}

**Why / how:** {{WHY_HOW}}

```
{{COMMANDS_IF_ANY}}
```

**What carries over / result:** {{CARRIES_OVER}}

**Verify:** {{VERIFY_NOTE}}

**Cost:** {{COST_e.g_$0}} · **Risk:** {{RESIDUAL_RISK_ONE_LINE}}

## What gets worse

<!-- OPTIONAL: keep only if there are honest trade-offs to disclose. -->
- {{HONEST_DOWNSIDE}}

## Out of scope (explicitly NOT doing)

<!-- OPTIONAL: what was deliberately excluded, and why. -->
- **{{EXCLUDED_ITEM}}** — {{WHY_EXCLUDED}}

## Recommended sequence

1. {{STEP_IN_ORDER}}

## Verification

| Check | Command / where | Expected | Status |
|---|---|---|---|
| {{CHECK}} | `{{COMMAND}}` | {{EXPECTED}} | [PENDING] |

## Rollback

| If this went wrong | Undo with |
|---|---|
| {{FAILURE_MODE}} | `{{UNDO_COMMAND}}` |

## How to use this doc

This runbook is the plan of record: written before execution, reviewed by the owner, and work starts only after go-ahead. As steps complete, chips flip [PENDING] → [IN PROGRESS] → [DONE] with a dated *Completed:* note, so the doc always mirrors reality. Open it in Chrome with MD Pretty Viewer for the formatted view (Ctrl+Shift+L switches light/dark). Last updated: {{DATE}}.
