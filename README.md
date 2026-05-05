# Skills

Personal Codex/agent skills live here as one top-level directory per skill:

```text
my-skill/
  SKILL.md
  agents/openai.yaml        # optional UI metadata
  scripts/                  # optional deterministic helpers
  references/               # optional docs loaded on demand
  assets/                   # optional templates, images, examples
```

This repo is the source of truth. Skill discovery is handled by symlinking each
skill directory into `~/.agents/skills`.

## Create A Skill

```bash
./scripts/new-skill.sh my-skill
```

Then edit `my-skill/SKILL.md`. Keep skills compact and put bulky details in
`references/` so agents only load them when needed.

## Link Skills Globally

```bash
./scripts/link-skills.sh
```

The linker scans this repo for top-level directories containing `SKILL.md` and
creates symlinks under `~/.agents/skills`. Existing non-symlink directories are
left untouched so manually installed skills are not overwritten.

To link a different target directory:

```bash
AGENTS_SKILLS_DIR="$HOME/.codex/skills" ./scripts/link-skills.sh
```

