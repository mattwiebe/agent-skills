# Routing Map

Use this file to record confirmed mappings from recurring voicenote language to
projects, repos, tools, people, admin areas, or journal handling preferences.

Do not treat tentative guesses as confirmed. Add entries only after user feedback
or an explicit instruction.

## Confirmed Destinations

| Cue | Destination | Notes |
| --- | --- | --- |
| Nada Sagrada | `~/Atziluth/themis` | Bar name. User may also say "Nada". |
| Nada | `~/Atziluth/themis` | Short form for Nada Sagrada when context is bar/business operations. |
| Natusigrada | `~/Atziluth/themis` | Treat as likely transcription error for Nada Sagrada. |
| bar stock / inventory / lot / receipt / staff texting | `~/Atziluth/themis` | Core Themis app/business-ops domain. |
| WhatsApp staff bot for Nada Sagrada | `~/Atziluth/themis` | No separate repo yet; should interface with Themis. WhatsApp Business number: +52-322-146-2620. Start by leaning on the Beeper Desktop API. |
| lots | `~/Atziluth/themis` | A lot is a delivery of stock items. |
| scenarios | `~/Atziluth/themis` | Legacy term for candidate recipes. Rename/migrate terminology to `pitches`. |
| pitches | `~/Atziluth/themis` | Candidate recipes. Replaces `scenarios`. |
| recipes | `~/Atziluth/themis` | Specified and costed recipes. |
| kitchen inventory | `~/Atziluth/themis` | Include in first stock-ops MVP, not phase 2. |
| voice note decomposition / candidate actions / routing feedback | `process-voicenote` skill and `~/inbox` | Do not auto-start downstream agents unless explicitly requested. |
| dispatch / send work to project / turn decomposition into project work | `process-voicenote` skill and destination repo `inbox/` | Use routed project destination from this map or the decomposition. Run routing clarification, write dispatch to destination repo inbox, then use explicit agent kickoff approval. |
| Themis dispatch / Nada dispatch | `process-voicenote` skill and `~/Atziluth/themis/inbox` | Concrete instance of the generic project dispatch flow. Themis owns concrete planning through repo-native instructions and the repo-inbox skill. |
| Elena reading lesson / homeschool / gym class / 8 p.m. bedtime / Spanish practice | `~/inbox/schedule.md` | Household Schedule. Separate destination from software projects and journal. |

## Recurring People And Collaborators

| Name or Cue | Relationship / Context | Routing Notes |
| --- | --- | --- |
| Elena | Household / family schedule | Route schedule and learning tasks to `~/inbox/schedule.md`. |
| Jacqueline | Household / family context | Route schedule/logistics to `~/inbox/schedule.md`; route relationship reflections to journal-only unless explicitly actionable. |

## Personal / Journal Handling

| Cue | Journal Treatment | Notes |
| --- | --- | --- |
| Relationship reflections | Journal-only by default. | Do not include in task briefs unless the user explicitly says otherwise. |
| Substance-use reflections | Journal-only by default. | Do not include in task briefs unless the user explicitly says otherwise. |
| Private emotional processing | Journal-only by default. | Keep operational tasks clean and minimally personal. |

## Feedback Log

Record concise feedback after processing notes.

| Date | Feedback | Resulting Map Change |
| --- | --- | --- |
| 2026-05-04 | Nada Sagrada/Nada/Natusigrada, bar stock, WhatsApp staff bot, lots/scenarios/recipes, and kitchen inventory all route to Themis at `~/Atziluth/themis`. Household routine routes to Household Schedule. Relationship and substance-use reflections are journal-only by default. | Added confirmed destination and privacy rules. |
| 2026-05-04 | Lots are deliveries of stock items. Scenarios should become pitches; pitches are candidate recipes; recipes are specified and costed. Start WhatsApp integration with Beeper Desktop API. There are no employees yet. Household Schedule lives at `~/inbox/schedule.md`. | Refined Themis domain terms, WhatsApp integration default, employee assumption, and household schedule destination. |
| 2026-05-04 | The skill should support a second-stage project dispatch flow and optionally kick off destination-side agents after clarification and explicit approval. Themis is the first concrete routed project. | Added generic dispatch routing and delegation protocol. |
