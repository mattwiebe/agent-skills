#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"

mkdir -p "$target_root"

linked=0
skipped=0

for skill_file in "$repo_root"/*/SKILL.md; do
  [[ -e "$skill_file" ]] || continue

  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target="$target_root/$skill_name"

  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "$skill_dir" ]]; then
      printf 'Already linked: %s -> %s\n' "$target" "$skill_dir"
    else
      ln -sfn "$skill_dir" "$target"
      printf 'Updated link: %s -> %s\n' "$target" "$skill_dir"
    fi
    linked=$((linked + 1))
  elif [[ -e "$target" ]]; then
    printf 'Skipped existing non-symlink: %s\n' "$target" >&2
    skipped=$((skipped + 1))
  else
    ln -s "$skill_dir" "$target"
    printf 'Linked: %s -> %s\n' "$target" "$skill_dir"
    linked=$((linked + 1))
  fi
done

printf 'Done. linked=%d skipped=%d target=%s\n' "$linked" "$skipped" "$target_root"

