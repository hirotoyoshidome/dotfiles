#!/usr/bin/env bash
# skills のみをリンクする(組織管理マシンでも実行可。環境設定には触れない)。
#   ~/.claude/skills       -> agents/skills
#   ~/.codex/skills/<name> -> agents/skills/<name>  (skill単位。同梱の .system を壊さないため)

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(dirname -- "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/agents/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Required directory not found: $SKILLS_DIR" >&2
  exit 1
fi

. "$SCRIPT_DIR/install-agents-common.sh"

link_path "$SKILLS_DIR" "$HOME/.claude/skills" "$HOME/.claude/backups"

for skill_dir in "$SKILLS_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_dir="${skill_dir%/}"
  skill_name="$(basename -- "$skill_dir")"
  link_path "$skill_dir" "$HOME/.codex/skills/$skill_name" "$HOME/.codex/backups"
done

echo "Done (skills)."
