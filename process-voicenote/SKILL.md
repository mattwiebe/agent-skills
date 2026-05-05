---
name: process-voicenote
description: Decompose rambling or chaotic voicenote transcripts into discrete reviewable work items, research tasks, journal items, open questions, and routing notes; dispatch clarified work packets to destination project inboxes; and, after explicit user approval, notify or kick off destination-side agents with scoped briefs. Use when the user asks to process a specific voice note, recent voice note, dictated transcript, qmd-indexed voicenote from the `voicenotes` collection, refine routing feedback, dispatch work from decomposed notes, or start downstream agents from approved dispatches.
---

# Process Voicenote

## Workflow

1. Retrieve the requested transcript from qmd.
2. Preserve uncertainty: do not invent missing context, project names, dates, or owners.
3. Convert the transcript into reviewable sections using the output contract below.
4. Separate personal reflection from executable work. Put personal material in a journal document section, not in task lists.
5. Write the output documents to `~/inbox` unless the user asks for response-only output or gives another path.
6. Do not start downstream agents or execute the decomposed tasks during initial decomposition unless the user separately asks for that.
7. Use `references/routing-map.md` to map recurring people, projects, systems, and phrasing to likely destinations. If the map is incomplete, add a routing note or open question instead of guessing too hard.

## Retrieval

Use the qmd skill and qmd CLI. Voice notes are indexed in the `voicenotes` collection.

For a specific date or recent note, prefer chronological listing before semantic search:

```bash
qmd ls voicenotes | tail -n 25
qmd ls voicenotes/2026/05 | tail -n 50
qmd get <path-or-docid>:1 -l 240
```

If the user provides memorable wording rather than a date, search the collection:

```bash
qmd query --json -c voicenotes $'intent: find a voicenote transcript to process\nlex: distinctive keywords\nvec: voice note transcript about the described topic'
```

If qmd returns several plausible notes, show the candidates with dates or paths and ask the user to choose. If one note is clearly requested, process it directly.

## Output Contract

Return two documents in the response:

1. `Voicenote Decomposition`
2. `Journal Items`

Use stable headings so the user can give routing feedback over time.

By default, also create `~/inbox` if needed and write the two documents as Markdown files:

- `~/inbox/YYYY-MM-DD-voicenote-decomposition.md`
- `~/inbox/YYYY-MM-DD-journal-items.md`

If multiple notes are processed for the same date, add a short distinguishing slug from the qmd path or transcript topic before `.md`. Mention the file paths in the final response.

`~/inbox` is indexed in qmd as the `inbox` collection, but this skill does not run `qmd update` or `qmd embed` after writing files.

### Voicenote Decomposition

Include these sections:

#### Inbox Summary

Summarize the note in 3-7 bullets. Capture the main projects, concerns, decisions, and context. Keep this descriptive, not task-heavy.

#### Proposed Tasks

List executable tasks. Each task should include:

- `Title`: imperative, specific, and short.
- `Context`: why this exists, including source detail from the transcript.
- `Likely Destination`: project, repo, app, person, or admin area if known.
- `Suggested Agent Brief`: a concise prompt that could be handed to a future agent.
- `Status`: use `needs review` unless the user explicitly pre-approved it.

Keep tasks atomic. Split tasks when they require different destinations, tools, or kinds of thinking. Merge duplicates that are clearly the same work.

#### Research Tasks

List tasks whose primary next step is investigation, reading, comparison, validation, or synthesis. Include:

- `Question`: the research question.
- `Why It Matters`: the decision or project it informs.
- `Likely Sources`: qmd, web, repo, docs, people, or specific systems.
- `Suggested Agent Brief`: a concise research prompt.
- `Status`: use `needs review`.

#### Open Questions

List ambiguities that block correct routing or execution. Prefer concrete yes/no or short-answer questions.

#### Routing Notes

Record mapping decisions, weak signals, and feedback-worthy assumptions. Mention when something should be added to `references/routing-map.md` after user confirmation.

### Journal Items

Create a separate journal-ready Markdown document with:

- `Date`: infer from the note path or user request when possible; otherwise use today's date.
- `Source`: qmd path or doc id if known.
- `Entries`: personal reflections, emotional context, life admin observations, ideas, and non-actionable thoughts.
- `Possible Follow-Up`: optional personal prompts or reminders, clearly separated from tasks.

Do not include sensitive personal material in task briefs unless it is necessary for the task. Keep journal wording faithful to the transcript and avoid over-therapizing.

## Routing Map

Read `references/routing-map.md` before finalizing when the transcript mentions recurring projects, tools, collaborators, or admin areas. Use it as a preference map, not a source of facts. When the current transcript reveals a new recurring mapping, propose an addition in `Routing Notes`; do not edit the map unless the user asks.

## Project Dispatch

Use this phase when the user asks to turn a decomposition into work for a software, admin, research, or operations project. This skill dispatches work to the destination; the destination repo owns concrete planning and implementation through its own instructions.

### Inputs

Read the relevant decomposition document from `~/inbox` and the routing map. Identify the destination project from `Likely Destination`, `Routing Notes`, or `references/routing-map.md`.

```bash
sed -n '1,220p' ~/inbox/<decomposition>.md
sed -n '1,180p' references/routing-map.md
```

Do not inspect destination repo internals as part of dispatch unless needed only to verify that the destination path exists and has or can receive an `inbox/` folder. The destination's own inbox workflow should inspect repo docs and code.

### Clarification Pass

Before producing dispatches, identify blocking routing questions. Ask only questions needed to choose the correct destination, split mixed-destination work, or avoid sending private/journal material to a project repo. Prefer 3-7 concrete questions.

Do not ask about items already confirmed in `references/routing-map.md`. Use confirmed routing facts as project defaults.

Current confirmed Themis defaults include:

- Themis repo: `~/Atziluth/themis`.
- Nada Sagrada, Nada, bar stock, inventory, lots, receipts, staff texting, WhatsApp bot, kitchen inventory: Themis.
- WhatsApp number: `+52-322-146-2620`.
- First WhatsApp integration path: Beeper Desktop API.
- Lots: deliveries of stock items.
- Pitches: candidate recipes, replacing legacy `scenarios`.
- Recipes: specified and costed recipes.
- Employees: none yet; early workflows can assume founder/admin use.

### Dispatch Contract

For each confirmed local project destination, create or use a repo-root `inbox/` folder and write a Markdown dispatch:

```text
<repo>/inbox/YYYY-MM-DD-<source-or-topic>-dispatch.md
```

The dispatch should include:

- `Source`: voicenote path, decomposition path, or user request.
- `Created`: date.
- `Destination`: repo path or project name.
- `Requested Outcome`: what the destination repo should plan or decide.
- `Context`: relevant source context, trimmed to what the destination needs.
- `Confirmed Facts`: routing/domain facts from `references/routing-map.md`.
- `Candidate Work`: proposed tasks and research questions for the destination to interpret.
- `Open Questions`: unresolved questions the destination may need to answer or ask back.
- `Out Of Scope`: journal-only, household, unrelated project, or explicitly deferred items.

Also write or update a short dispatch index in `~/inbox` when useful, but do not create the destination's implementation plan from this side.

For Themis-specific dispatches, the current routed repo is `~/Atziluth/themis`.

## Agent Kickoff Protocol

Use this only after dispatch files exist.

1. Ask the user to approve notifying or starting a destination-side agent for a specific dispatch file.
2. The agent brief should say to work in the destination repo, use the `repo-inbox` skill if available, read the dispatch file, and follow repo-native instructions.
3. Do not specify repo internals, file ownership, or implementation strategy from this side unless the destination repo's own docs already say so.
4. After destination-side agents finish, record the result or returned plan in `~/inbox` or the destination repo's inbox according to the user's preference.

## Quality Bar

- Convert messy phrasing into crisp tasks without losing nuance.
- Mark speculation explicitly with `possibly` or `unclear`.
- Prefer fewer high-quality tasks over a long undifferentiated list.
- Keep downstream agent briefs self-contained enough to be useful later.
- Never execute, delegate, email, file tickets, or modify project source files during initial decomposition unless the user makes a separate explicit request. For project dispatch follow-up, kickoff agents only through the Agent Kickoff Protocol.
