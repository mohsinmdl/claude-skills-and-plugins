# Runbook authoring patterns (read when filling a fresh non-trivial runbook)

Extends the core SKILL.md. Two parts: proven optional patterns (some marked `<!-- OPTIONAL -->` in `template.md`), and guidance for shaping/adding bespoke sections.

## Optional patterns (proven in real docs — use when they help, delete when they don't)

Keep the ones that fit the doc; strip the rest. Everything is plain Markdown — the extension draws chips and cards from it.

- **Item anatomy** — the item body (under its `### N. Title [RISK] [STATUS]` heading) has a labeled skeleton (**What's involved** → **Why / how** → optional fenced commands → **What carries over / result** → **Verify**). Use it to keep each item self-contained; delete any label that doesn't apply. For a trivial one-line item, a single sentence is fine. The extension collapses each item's body into a **Brief** and adds an **Expand all / Collapse all** button — don't add `<details>` yourself.
- **Correction / changelog note** — when a claim in a runbook turns out **wrong**, do NOT silently overwrite it. Add a `[CORRECTED {date}]` chip to the item heading and a note `*Correction {date}: originally said X; actually Y.*`. This keeps the "doc mirrors reality" honesty — the reader sees what changed and why.
- **Disposition chip** (any other uppercase bracket word, e.g. `[REBUILD]`) — an optional extra chip tagging the *kind* of work, separate from risk: e.g. `REBUILD`, `PORTABLE`, `STALE`, `REPROVISION`, `REINSTALL`. For feasibility/migration docs it can also become a summary-table column; for plain execution runbooks, usually skip it.
- **Risk-legend line** — the line under the meta block (`[HIGH] … · [MED] … · [LOW] … · [PORTABLE] …`) defines what HIGH/MED/LOW/PORTABLE mean *for this doc*. Keep it for risk/feasibility docs; delete it for simple execution runbooks where the chips are self-explanatory.
- **Cost + Risk item footer** — end each item with `**Cost:** … · **Risk:** …`. Forces a per-item statement of price and residual blast radius. Drop the Cost half when nothing costs money.
- **Effort column** — the summary table has an optional `Effort` column (rough per-item time, e.g. `~5 min`, `~1 hr`). Great for tracker/checklist runbooks; delete the `Effort` column for feasibility docs where time-per-item isn't meaningful.
- **"Out of scope (explicitly NOT doing)" section** — list what was *deliberately* excluded and why. Distinct from "What gets worse" (which is honest downsides of what you ARE doing). Keeps priority honest and pre-empts scope creep. Delete if nothing was consciously cut.
- **Priority axis instead of risk** — an item's severity chip/border can express **risk** (how dangerous — default: `[HIGH]` `[MED]` `[LOW]` chips) OR **priority** (how urgent/important — `[P1]` `[P2]` `[P3]` chips; the item's rail follows whichever it carries). Use priority for hardening/backlog/follow-up docs that think in P1/P2/P3; rename the summary column "Risk"→"Pri" and add a matching priority-legend. Keep risk for feasibility/change docs. Pick one axis per doc — don't mix.

## Shape the doc to the task — add, rename, and cut sections freely

The template is a **starting point, not a contract**. It offers an always-useful spine (meta, verdict, decisions, summary, items, verification, rollback), but every runbook should be shaped to its task in both directions:

- **Add / rename:** actively ask *"What would make THIS doc genuinely useful that the template doesn't already cover?"* — then add bespoke `##` sections, or rename stock headings to task-specific ones that say it better (e.g. "Cutover window" instead of "Recommended sequence", "What the auditor will ask" instead of "Verification").
- **Cut:** any stock section that doesn't earn its place goes — an empty or filler-filled section is worse than no section (only the ops Verification/Rollback omissions need the one-line why-note from the core rules).

**Rules for added sections:**
- Use plain Markdown only — tables (with a Status chip column if anything is trackable), bracket chips, lists, `code`/fenced blocks, bold labels. **Never write HTML or CSS** — if a section seems to need styling the extension doesn't offer, ask the user.
- Place them where they read best (usually after the summary or after the items). Match the house style: `##` heading, concise prose, tables over walls of text.
- Add only what earns its place. Two sharp bespoke sections beat ten generic ones.

**Menu of high-value candidates (pick per task — this list is a prompt, not a checklist):**

| Add when the task… | Section to add |
|---|---|
| moves/reshapes a system | **Before → After** two-column table (current state vs target) |
| has data flow or topology | **Architecture / flow** — an ASCII diagram in a fenced block, or a labeled step list |
| chose among real alternatives | **Alternatives considered** — options + why-rejected (distinct from the locked *decisions*) |
| rests on unverified beliefs | **Assumptions & open questions** — what's taken as true, what's still unknown |
| touches money/disk/quota/tokens | **Cost / resource impact** — estimates before vs after |
| needs things in place first | **Prerequisites / dependencies** — what must be true before step 1 |
| could break other things | **Blast radius** — who/what is affected if it goes wrong |
| has a fuzzy "done" | **Success criteria / metrics** — measurable done, separate from mechanical verification |
| is dense with IDs/hosts/accounts | **Key entities** — a reference table of the specific instances (hosts, account IDs, buckets); the always-on Glossary already covers service names and acronyms |
| touches creds/permissions/data | **Security considerations** |
| spans people or days | **Timeline / owners** — phases with who + when |
| is an incident write-up | **RCA shape** — timeline → root cause → contributing factors → action items |
| ships user-facing UI | **Visual states / screenshots**, or a **test matrix** (cases × platforms) |

When in doubt, invent a section the menu doesn't list — the goal is a doc that fits the task, and thinking beyond this menu is encouraged.
