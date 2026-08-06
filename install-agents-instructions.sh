#!/usr/bin/env bash
# グローバル指示のみをリンクする(組織管理マシンでも実行可。環境設定には触れない)。
#   ~/.claude/CLAUDE.md -> agents/AGENTS.md
#   ~/.codex/AGENTS.md  -> agents/AGENTS.md

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
AGENTS_MD="$SCRIPT_DIR/agents/AGENTS.md"

if [ ! -f "$AGENTS_MD" ]; then
  echo "Required file not found: $AGENTS_MD" >&2
  exit 1
fi

. "$SCRIPT_DIR/install-agents-common.sh"

link_path "$AGENTS_MD" "$HOME/.claude/CLAUDE.md" "$HOME/.claude/backups"
link_path "$AGENTS_MD" "$HOME/.codex/AGENTS.md" "$HOME/.codex/backups"

echo "Done (instructions)."
