# Saving an approved plan as a runbook (read when the user says yes to the offer)

The approved markdown plan is the working plan — execution starts from it immediately. The HTML build is handed to a **background subagent** so the main session never stalls on template-filling. (This is the opposite of the ops/infra document-first flow, where the runbook must exist and be reviewed before anything runs — never background that one.)

## Main session: dispatch, then execute

1. **Pick the destination path yourself** (do not leave it to the subagent): same rules as core SKILL.md — project `docs/runbooks/` if it exists, else project `docs/`, else `~/docs/`; kebab-case filename; check for an existing runbook covering this work (update it instead of duplicating); apply the sensitive-content gitignore gate.
2. **Dispatch ONE background subagent** via the Agent tool. The dispatch prompt is self-contained (the subagent has no conversation context) and contains, verbatim:
   - the full approved plan text (markdown, unabridged);
   - the absolute `<skill-dir>` path and the absolute destination path from step 1;
   - the "Subagent task" block below, copied in full.
3. **Start executing the plan from the markdown immediately** — do not wait for the subagent or poll it.
4. **On the subagent's completion notification:** give the user the `file:///…` path; flip chips for any steps that already completed while the HTML was being built (dated notes per SKILL.md "During and after execution"); append the catch-up to the `Updated:` line. From then on keep the doc current as usual.
5. **No Agent tool available, or the dispatch fails?** Build the runbook inline yourself (follow the "Subagent task" block), at the next natural pause in execution.
6. **User says no to saving?** Proceed with the plan directly — do not create the file.

## Subagent task (copy this block into the dispatch prompt)

You are building an HTML runbook from an already-approved plan. Steps:

1. `cp "<skill-dir>/template.html" <dest>.html` — never Read the template itself, never write HTML boilerplate or CSS.
2. Read `<skill-dir>/SKILL.md` and follow its filling rules and always-on conventions (Status chips, verdict column, item-card risk classes, Glossary, `Updated:` line, "Verified via" evidence). Read `<skill-dir>/references/authoring-patterns.md` for any non-trivial runbook.
3. Read the fresh copy of `<dest>.html` once, then fill it with targeted Edit calls. Map the plan onto the template: plan Context → meta block Purpose/Context; the decision(s) made → locked-decisions table; each implementation step → a summary row + item-card (risk class by judgment); the plan's verification section → verification table; undo strategy → rollback table.
4. Initial state: every item/verification chip `<span class="status pending">PENDING</span>`; the H1 chip `<span class="status in-progress">IN PROGRESS</span>` — the plan is already approved and execution has begun, so there is no `AWAITING REVIEW` gate.
5. `grep -n '{{' <dest>.html` must return nothing; fix every hit. Return the absolute destination path as your result.

## Pre-deployment code reviews

Code reviews map the same way: each finding → a summary row + item-card with the risk chip set by severity, the review's overall verdict → headline Verdict, fix-confirmation checks → verification table, and "ship / hold" → the H1 chip (`AWAITING REVIEW` until the user signs off). Build these **inline, not via subagent** — the review doc is itself the deliverable awaiting sign-off; there is no execution to run in parallel.
