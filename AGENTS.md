# Repository Conventions

This repository stores reusable agent skills. Treat each top-level directory
containing `SKILL.md` as one skill.

## Skill Rules

- Use lowercase letters, digits, and hyphens for skill directory names.
- Keep `SKILL.md` concise and procedural.
- Include only `name` and `description` in YAML frontmatter.
- Put detailed reference material in `references/`.
- Put deterministic helpers in `scripts/` and test them before relying on them.
- Put templates, media, or reusable source artifacts in `assets/`.
- Add `agents/openai.yaml` when useful for UI metadata.

## Repo Rules

- Do not replace `~/.agents/skills` wholesale; link individual skill folders.
- Run `./scripts/link-skills.sh` after adding or renaming a skill.
- Avoid committing generated caches, local environment files, or build outputs.

