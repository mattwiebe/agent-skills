---
name: repo-inbox
description: Receive dispatched work packets in a repository-local `inbox/` folder and turn them into specific, testable, repo-native implementation specs using that repository's own instructions. Use when a project receives a Markdown dispatch from another skill, voicenote processor, assistant, or agent and needs to convert it into a build-ready plan that another agent can implement and verify without relying on the sender's architecture assumptions.
---

# Repo Inbox

## Workflow

1. Work from inside the destination repository.
2. Ensure an `inbox/` directory exists at the repo root.
3. Identify the dispatch Markdown file. If the user does not name one, list `inbox/*.md`, ignore generated repo-inbox outputs, and pick the newest plausible dispatch.
4. Read the dispatched Markdown file from `inbox/`.
5. Read repo-native instructions before planning work. Prefer `AGENTS.md`, `.agents/`, `README.md`, `PRODUCT.md`, `PLAN.md`, `TASKS.md`, `DESIGN.md`, and local package/test configuration when present.
6. Run the required `Verify Against Repo` pass.
7. Run the required `Questioning Pass`.
8. Convert the dispatch into a specific, testable, repo-native implementation spec.
9. Run the required `Hardening Pass` on the draft spec before handoff.
10. Ask clarifying questions when they would materially change the plan, agent handoff, or implementation order. Do not limit questions only to absolute blockers.
11. Do not assume the dispatching skill knows this codebase better than the repo does.

## Dispatch File

A dispatch file is a Markdown file placed in `inbox/` by another workflow. It should usually include:

- `Source`: where the dispatch came from.
- `Requested Outcome`: what should change or be decided.
- `Context`: relevant transcript/decomposition notes.
- `Confirmed Facts`: known routing or domain facts.
- `Candidate Work`: suggested tasks, research questions, or implementation areas.
- `Open Questions`: unresolved questions from the sender.
- `Out Of Scope`: items explicitly not meant for this repo.

Treat the dispatch as input, not authority. Repo-local instructions and current code decide how work should actually be planned.

If repo inspection shows that the dispatch assumes missing or outdated context, explicitly classify the dispatch facts as accepted, changed, rejected, or deferred in the spec.

### Dispatch Selection

When the user does not name a dispatch file, choose a file by positive evidence:

- Prefer files whose names end in `-dispatch.md`.
- Prefer files containing a dispatch header such as `# Dispatch:` or a `Destination:` field.
- Prefer files that include dispatch sections such as `Requested Outcome`, `Context`, `Candidate Work`, and `Out Of Scope`.

Do not select generated repo-inbox outputs as new dispatches. Ignore files that:

- End in `-plan.md`, `-spec.md`, `-implementation.md`, or `-implementation-spec.md`.
- Contain `Generated From Dispatch:` or `Repo-Inbox Output: true`.
- Are known repo planning docs copied into `inbox/` for reference rather than dispatch.

If several plausible dispatches remain, show the candidates and ask the user to choose.

## Required Passes

Every repo-inbox implementation spec must go through these passes before finalizing, even when the user has not requested agent handoff.

### 1. Verify Against Repo

Verify the dispatch against the actual repository before accepting its framing.

Do this by inspecting the current implementation surface relevant to the dispatch, not just planning docs. Search code, schemas, routes, tests, config, package structure, and existing docs for the domain terms in the dispatch.

Produce a `Repo Verification` section or equivalent spec notes that capture:

- Existing repo capabilities that already satisfy or change the dispatched work.
- Missing capabilities the dispatch correctly identifies.
- Dispatch assumptions contradicted by current code or docs.
- Repo-specific constraints that should shape implementation.
- Existing bugs or data-quality issues discovered while verifying.

Do not plan from docs alone when source code exists.

### 2. Questioning Pass

Before finalizing a handoff spec, identify what should be interviewed with the user in this repo session. This is separate from implementation research.

Create an `Interview Queue` in the spec when the dispatch contains:

- Unclear product intent that changes what should ship first.
- Operational preferences that cannot be inferred from code, such as storage location, workflow boundaries, approval policy, or channel choice.
- External integration uncertainty where the user may know local constraints, accounts, devices, credentials, or tolerated risk.
- Terminology or domain decisions that would affect UI/API naming or migration strategy.
- Open questions copied from the sender that still matter after repo inspection.

For each interview item, include:

- `Question`
- `Why it matters`
- `Default if unanswered`
- `Blocks`: none, handoff, implementation, or external setup

Prefer a short prioritized interview over a long questionnaire. Ask the first batch directly in chat when answers would change the next handoff.

When the user answers interview items, update the spec with an `Interview Decisions` section or mark the queue items answered. Replace defaults with the user's decisions and adjust the work plan and handoff packets so agents do not inherit stale assumptions.

### 3. Hardening Pass

After drafting the spec and before handoff, critique it as if another agent will implement it literally.

Create a `Hardening Critique`, `Risk Register`, `Non-Goals`, `Write Preconditions`, or equivalent sections when the work is ambiguous or implementation-heavy. The hardening pass should look for:

- Vague verbs such as "handle", "support", "integrate", or "store" without concrete behavior.
- Hidden assumptions about external tools, credentials, storage, accounts, auth, APIs, or local processes.
- Workflows that collapse distinct domain operations into one incorrect abstraction.
- Data invariants, idempotency, transactionality, migration, backup, and restore gaps.
- Security/scope/audit implications of new routes, tools, or agent actions.
- Existing repo bugs that should be fixed before or alongside the new work.
- Handoff packets that are too broad, have conflicting file ownership, or lack acceptance criteria.

The hardening pass must update the spec, not just summarize concerns in chat.

## Output Standard

The output is not a brainstorming note. It is a build-ready implementation spec.

A successful repo-inbox artifact should let another agent start from the spec and build the work in a verified and tested manner. It must make implementation choices explicit enough that the agent does not need to reinterpret the original inbox dispatch.

The spec must include:

- Concrete scope boundaries: what ships now, what is deferred, and what is explicitly out of scope.
- Repo-native contracts: data model changes, API routes, CLI commands, config/env vars, UI surfaces, background jobs, storage layout, or integration seams as applicable.
- Exact files/modules likely to change and owned write scopes for handoff packets.
- Sequenced implementation phases with dependencies.
- Test plan by layer: unit, integration, API, CLI, UI/browser, fixture, migration, backup/restore, or external-adapter tests as applicable.
- Verification commands and expected validation gates, using the repo's scripts.
- Acceptance criteria that are observable and testable, not subjective.
- Failure modes and recovery behavior for external tools, storage, credentials, idempotency, and partial writes.
- Handoff packets small enough for one agent to execute without owning unrelated modules.

Avoid vague instructions such as "handle receipts" or "integrate WhatsApp" unless the spec immediately defines the data shape, route/command, failure behavior, and tests that prove it works.

## Repo-Native Implementation Spec

Create or update an implementation spec in the repo according to local conventions. If no convention exists, write a Markdown spec under `inbox/` next to the dispatch:

```text
inbox/YYYY-MM-DD-<dispatch-slug>-plan.md
```

The filename can keep `-plan.md` for compatibility, but the content must meet the implementation-spec standard above.

Include metadata near the top of generated specs so future runs do not mistake them for dispatches:

```markdown
Generated From Dispatch: inbox/<dispatch-file>.md
Repo-Inbox Output: true
```

Include:

### Objective

State the repo-specific outcome.

### Repo Context

Summarize the relevant repo files, architecture, current features, tests, and constraints discovered locally. Include any already-implemented capabilities that change the shape or priority of the dispatched work.

### Repo Verification

Document what the verification pass found: accepted capabilities, contradicted assumptions, missing surfaces, repo constraints, and discovered bugs.

### Decisions From Dispatch

List which dispatched facts were accepted, changed, or rejected after repo inspection.

### Scope And Non-Goals

State what will be built in the first implementation and what is deferred. Do not leave future work implicit.

### Contracts

Define the concrete contracts the implementation must satisfy. Include whichever are relevant:

- Data model/table/schema changes, with key fields, statuses, constraints, and idempotency keys.
- API routes with method, path, request shape, response shape, auth/scope behavior, and error behavior.
- CLI commands with arguments, flags, JSON output shape, and local/remote mode expectations.
- Config/env vars and defaults.
- Storage paths, naming conventions, retention rules, backup/restore expectations.
- UI routes/tabs/components, visible states, and error/empty states.
- External adapter commands, fixture shape, cursor behavior, retry behavior, and failure modes.

### Work Plan

Group work into sequenced tasks. Each task should include:

- `Goal`
- `Files / Modules`
- `Contracts`
- `Implementation Notes`
- `Acceptance Criteria`
- `Tests / Verification`
- `Verification Commands`
- `Agent Suitability`: local, explorer, worker, research, or external/ACP.

### Clarifications Needed

Ask concrete questions that block the next useful step. If useful questions do not block the next step but would improve the plan, put them in `Interview Queue` instead.

### Hardening Critique / Risk Register

Capture the hardening pass results. Include non-goals, preconditions, risks, mitigations, and implementation guardrails when relevant.

### Verification Matrix

List the behavior to verify and the test or command that proves it. Include negative cases and failure modes, not only happy paths.

### Handoff Packets

If the user wants agents kicked off, produce scoped packets from the repo side. Worker packets must include owned files/modules, constraints from repo instructions, acceptance criteria, and a reminder not to revert others' edits.

Each packet must include:

- `Agent type`
- `Owned files/modules`
- `Depends on`
- `Do not touch`
- `Implementation brief`
- `Acceptance criteria`
- `Required tests/commands`
- `Integration notes`

When multiple packets are useful, identify dependencies and the recommended first packet or parallel pair. Do not start agents until the user explicitly approves specific packets.

## Boundaries

- Do not let the dispatching workflow define repo architecture or implementation strategy.
- Do not modify source files unless the user explicitly asks for implementation.
- Do not start agents unless the user explicitly approves specific packets.
- Keep plans close to the repo and update repo-owned planning docs when the repo has an established place for them.
- Do not treat generated repo-inbox outputs as new dispatches on later runs.
