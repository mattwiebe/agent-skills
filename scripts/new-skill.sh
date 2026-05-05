#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s <skill-name> [--resources scripts,references,assets]\n' "$0" >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

skill_name="$1"
shift

resources=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --resources)
      if [[ $# -lt 2 ]]; then
        usage
        exit 2
      fi
      resources="$2"
      shift 2
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

if [[ ! "$skill_name" =~ ^[a-z0-9][a-z0-9-]{0,62}$ ]]; then
  printf 'Invalid skill name: %s\nUse lowercase letters, digits, and hyphens only.\n' "$skill_name" >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_dir="$repo_root/$skill_name"

if [[ -e "$skill_dir" ]]; then
  printf 'Skill already exists: %s\n' "$skill_dir" >&2
  exit 1
fi

mkdir -p "$skill_dir"

cat > "$skill_dir/SKILL.md" <<EOF
---
name: $skill_name
description: TODO: Describe what this skill does and the specific user requests or contexts that should trigger it.
---

# $skill_name

## Workflow

1. TODO: Add the shortest reliable procedure for using this skill.

## Resources

- TODO: Mention any files in \`references/\`, \`scripts/\`, or \`assets/\` and when to use them.
EOF

if [[ -n "$resources" ]]; then
  IFS=',' read -r -a resource_list <<< "$resources"
  for resource in "${resource_list[@]}"; do
    case "$resource" in
      scripts|references|assets)
        mkdir -p "$skill_dir/$resource"
        ;;
      "")
        ;;
      *)
        printf 'Unknown resource directory: %s\n' "$resource" >&2
        exit 2
        ;;
    esac
  done
fi

printf 'Created %s\n' "$skill_dir"

