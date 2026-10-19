---
name: runbook
description: Create a Markdown runbook/plan-of-record BEFORE executing any task that has a pre-execution plan worth documenting — ops, infra, machine-setup, migration, deployment, config changes, features, refactors, pre-deployment code reviews. For ops/infra it is mandatory and comes before plan review (the user reviews the runbook, not a chat plan). For any other planned task, offer to save the approved plan as a runbook before executing. Also use when the user types /runbook, or when flipping status chips after steps complete.
license: MIT
---

# Markdown Runbook (document-first workflow)

The rule: for ops/infra work, the plan of record is written into a `.md` runbook FIRST, the user reviews **the runbook** (not a chat message), and execution starts only on their go-ahead. As steps complete, chips flip so the doc always mirrors reality.

For **any other planned task** (feature, refactor, config change, …): after a plan is approved, ask the user whether to save it as a runbook before executing — if yes, do **not** build the runbook in this session: read `<skill-dir>/references/plan-to-runbook.md` and follow its dispatch recipe to hand the build to a background subagent, then start executing the plan immediately — the approved markdown plan is enough to work from; the runbook catches up in parallel. (The reference also covers pre-deployment code reviews, which stay inline.)

`<skill-dir>` below means this skill's own directory (where this SKILL.md lives — the path is shown when the skill loads). If it isn't evident: `find ~/.claude/plugins ~/.claude/skills -path '*runbook/template.md' -print -quit 2>/dev/null`.

**How runbooks are viewed:** a runbook is plain Markdown with `runbook: true` frontmatter. The user's Chrome extension **MD Pretty Viewer for Chrome** renders such files as runbooks (chips, item cards, progress, outline). Write only Markdown — never HTML, CSS or `<span>` markup; the extension owns the look.

## Creating a runbook

1. **Copy the template:**
   ```bash
   cp "<skill-dir>/template.md" <dest>.md
   ```
   Destination: the project's `docs/runbooks/` folder if it exists, else the project's `docs/`, else `~/docs/`. Kebab-case descriptive filename (e.g. `main-account-handover.md`).
   - **Check for an existing runbook first** (`.md` or older `.html`) — a doc already covering this work gets updated (chips, `Updated:` line, correction notes), not near-duplicated.
   - **Sensitive-content gate:** if the runbook will hold infra/access detail (IPs, hostnames, account IDs, creds paths) and the destination is inside a git repo, verify the path is gitignored (`git check-ignore -q <dest> && echo ignored`); if not, use a gitignored location or `~/docs/` — never let a sensitive runbook become committable.

2. **Read the fresh copy once, then fill it with targeted Edit calls.** It has `{{PLACEHOLDER}}` markers for: title, meta block, risk-legend line, verdict, locked decisions, summary rows, glossary rows, items, downsides, out-of-scope, sequence, verification rows, rollback rows, footer date. Duplicate the example row/item per real entry. Non-negotiable rules:
   - **Keep the frontmatter** (`runbook: true`) — without it the extension shows a plain document.
   - **Chips are bracket words:** status `[PENDING]`, `[AWAITING REVIEW]`, `[IN PROGRESS]`, `[DONE]`, `[BLOCKED]` (use these five), plus `[CORRECTED 2026-07-07]`; risk `[HIGH]` `[MED]` `[LOW]` `[PORTABLE]`; priority `[P1]` `[P2]` `[P3]`. The leading word picks the style (`VERIFIED`, `PASS`, `FIXED`, `MERGED` also read as done; `FAIL`, `ON HOLD`, `DEFERRED` as blocked; `TODO`, `PLANNED` as pending). The text before any ` — ` must be uppercase; a lowercase reason after it is fine: `[BLOCKED — waiting on DNS]`, `[DONE — build green]`. Any other uppercase bracket text becomes a neutral tag (e.g. `[REBUILD]`). To force a style on custom text: `[done: Shipped 2026-10-20]`. Never put chips inside backticks.
   - **Items:** under `## Items` (`## Steps`, `## Phases`, `## Tasks`, `## Item details` and `## Step details` also work; the first such section is used), one `### N. Title [RISK] [STATUS]` heading per item; everything until the next `###`/`##` is that item's collapsible brief. The renderer gives it the id `item-N` and a severity rail from the risk chip. To group items into phases, put an **unnumbered** `### Phase 1 — Rollout` heading between them: it shows as a group label and is not counted as an item. Keep every real item numbered (`1.`, or `A1.` for lettered groups).
   - Every item/step-tracking table has a **Status column with a chip**; the summary table's **One-line verdict** column is always filled; the **item title** (not the number) links to `#item-N`.
   - **Meta block:** keep it as the first blockquote, one `> **Label:** value \` line per field (the trailing `\` keeps each on its own line).

3. **Shape the doc to the task.** Any stock section is skippable, headings are renameable/inventable, bespoke sections are encouraged — one honesty rule: if an ops/infra runbook drops Verification or Rollback, leave a one-line note saying why. Before filling any non-trivial runbook, read `<skill-dir>/references/authoring-patterns.md` (proven optional patterns + a menu of high-value bespoke sections); a short simple runbook can skip it.

4. **Always-on conventions (not optional):**
   - **Glossary section** — every runbook: one table of services/tools named in the doc (plain-language what-it-is + role here) and one expanding every acronym. Self-contained for a reader who doesn't know the stack; when a later edit introduces a new name, add it to the Glossary in the same edit.
   - **`Updated:` line** in the meta block — a running dated changelog (starts `—` for a new doc; append an entry on every material change). Write every entry as `YYYY-MM-DD — what changed.` on the same line, oldest first: `2026-07-07 — items 1–2 done. 2026-07-08 — item 3 blocked on DNS.` The viewer turns these into a dated list (latest three shown, older ones folded), so the date-dash prefix is required.
   - **"Verified via" evidence** — back factual claims with the command that proved them, inline. Don't assert state you didn't observe.
   - **Custom chip text is fine** — `[AWAITING USER]`, `[SOAK UNTIL 2026-06-27]`, `[BLOCKED — waiting on DNS]`.

5. **Write for scanning.** Readers skim chips and verdicts first and open a brief only when they need detail:
   - **Verdict:** 1–2 sentences that lead with the answer. **One-line verdict** cells: 12 words or fewer.
   - **Item labels** (*What's involved*, *Why / how*, …): 1–3 sentences each; anything longer becomes a list.
   - **Notes:** 2 sentences or fewer — what happened plus the evidence; extra detail goes in the item body or a command block.
   - **Changelog entries:** one short clause each.
   - Use a list for 3+ parallel things and a table for things compared on the same attributes; never a long paragraph of either.
   - One idea per sentence, in plain words; names are defined in the Glossary, not explained inline.
   - Commands go in fenced code blocks, not inside sentences; inline code is for names, paths and values only.

6. **Initial state:** every item/verification chip is `[PENDING]`; the H1 chip is `[AWAITING REVIEW]`.

7. **Pre-handoff check, then stop:** `grep -n '{{' <dest>.md` — any hit is an unfilled placeholder or leftover template comment; fix every one. Then open it in the user's **default browser** (not the default app for `.md`, which is usually an editor) and STOP:
   ```bash
   bash "<skill-dir>/scripts/open-in-browser.sh" <dest>.md
   ```
   It prints the `file:///…` URL it opened — give that to the user too, and ask them to review the runbook. Do not begin execution. (The formatted view needs MD Pretty Viewer for Chrome in that browser, with "Allow access to file URLs" on; if the script can't open a browser, just give the path.)

## During and after execution

- On go-ahead: flip the H1 chip to `[IN PROGRESS]`.
- As each step completes: flip its chip to `[DONE]` (in the item heading **and** its summary row) and append a dated note at the end of the item. Blocked steps get `[BLOCKED — reason]` and a Blocked note.
- When a claim turns out **wrong**: never silently overwrite — add a `[CORRECTED 2026-07-07]` chip to the item heading and a Correction note.
- **Note formats.** Each note is its own paragraph, wrapped whole in one `*…*`, label first — the viewer shows it as an upright, labelled block:
  - `*Completed: 2026-07-07 — what actually happened.*`
  - `*Correction 2026-07-07: originally said X; actually Y.*`
  - `*Blocked: 2026-07-07 — what it waits on.*`
  - `*Note: anything else worth keeping beside the item.*`
- When everything is done: H1 chip → `[DONE]`, update the footer "Last updated" date.
- Every material update (chip flip, correction, new item) also appends a dated entry to the `Updated:` line in the meta block — don't let the changelog go stale while chips move.
