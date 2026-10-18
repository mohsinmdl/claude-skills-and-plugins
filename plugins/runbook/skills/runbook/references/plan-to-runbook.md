# Saving an approved plan as a runbook (read when the user says yes to the offer)

The approved markdown plan is the working plan — execution starts from it immediately. The runbook build is handed to a **background subagent** so the main session never stalls on template-filling. (This is the opposite of the ops/infra document-first flow, where the runbook must exist and be reviewed before anything runs — never background that one.)

## Main session: dispatch, then execute

1. **Pick the destination path yourself** (do not leave it to the subagent): same rules as core SKILL.md — project `docs/runbooks/` if it exists, else project `docs/`, else `~/docs/`; kebab-case filename; check for an existing runbook covering this work (update it instead of duplicating); apply the sensitive-content gitignore gate.
2. **Dispatch ONE background subagent** via the Agent tool. The dispatch prompt is self-contained (the subagent has no conversation context) and contains, verbatim:
   - the full approved plan text (markdown, unabridged);
   - the absolute `<skill-dir>` path and the absolute destination path from step 1;
   - the "Subagent task" block below, copied in full.
3. **Start executing the plan from the markdown immediately** — do not wait for the subagent or poll it.
4. **On the subagent's completion notification:** open it in the user's default browser (`bash "<skill-dir>/scripts/open-in-browser.sh" <dest>.md`) and give the `file:///…` URL it prints; flip chips for any steps that already completed while the runbook was being built (dated notes per SKILL.md "During and after execution"); append the catch-up to the `Updated:` line. From then on keep the doc current as usual.
5. **No Agent tool available, or the dispatch fails?** Build the runbook inline yourself (follow the "Subagent task" block), at the next natural pause in execution.
6. **User says no to saving?** Proceed with the plan directly — do not create the file.

## Subagent task (copy this block into the dispatch prompt)

You are building a Markdown runbook from an already-approved plan. Steps:

1. `cp "<skill-dir>/template.md" <dest>.md` — never write HTML or CSS; chips are bracket words like `[PENDING]`.
2. Read `<skill-dir>/SKILL.md` and follow its filling rules and always-on conventions (frontmatter, bracket chips, `### N. Title [RISK] [STATUS]` items, verdict column, Glossary, `Updated:` line, "Verified via" evidence). Read `<skill-dir>/references/authoring-patterns.md` for any non-trivial runbook.
3. Read the fresh copy of `<dest>.md` once, then fill it with targeted Edit calls. Map the plan onto the template: plan Context → meta block Purpose/Context; the decision(s) made → locked-decisions table; each implementation step → a summary row + `### N.` item (risk chip by judgment); the plan's verification section → verification table; undo strategy → rollback table.
4. Initial state: every item/verification chip `[PENDING]`; the H1 chip `[IN PROGRESS]` — the plan is already approved and execution has begun, so there is no `AWAITING REVIEW` gate.
5. `grep -n '{{' <dest>.md` must return nothing; fix every hit. Return the absolute destination path as your result.

## Pre-deployment code reviews

Code reviews map the same way: each finding → a summary row + `### N.` item with the risk chip set by severity, the review's overall verdict → headline Verdict, fix-confirmation checks → verification table, and "ship / hold" → the H1 chip (`[AWAITING REVIEW]` until the user signs off). Build these **inline, not via subagent** — the review doc is itself the deliverable awaiting sign-off; there is no execution to run in parallel.
