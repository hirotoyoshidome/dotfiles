#!/usr/bin/env bash
# 環境設定(許可コマンド)を反映する。個人マシンでの実行を想定
# (組織管理マシンでは settings.json に組織の個別設定が入るため実行しない)。
#   ~/.claude/settings.json  permissions.allow キーのみマージ更新(他キーは維持)
#   ~/.codex/rules/my.rules -> .codex/rules/my.rules (generate-agents-assets.sh の生成物)

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(dirname -- "$SCRIPT_DIR")"
CODEX_RULES="$REPO_DIR/.codex/rules/my.rules"
REPO_CLAUDE_SETTINGS="$REPO_DIR/.claude/settings.json"

for required in "$CODEX_RULES" "$REPO_CLAUDE_SETTINGS"; do
  if [ ! -f "$required" ]; then
    echo "Required file not found: $required" >&2
    exit 1
  fi
done
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

. "$SCRIPT_DIR/install-agents-common.sh"

# permissions.allow のみ実機 settings.json へマージ(他キーは維持)
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
allow_json="$(jq '.permissions.allow' "$REPO_CLAUDE_SETTINGS")"
if [ -f "$CLAUDE_SETTINGS" ]; then
  if [ "$(jq --argjson allow "$allow_json" '.permissions.allow == $allow' "$CLAUDE_SETTINGS")" = "true" ]; then
    echo "ok (already merged): $CLAUDE_SETTINGS (permissions.allow)"
  else
    mkdir -p "$HOME/.claude/backups"
    cp "$CLAUDE_SETTINGS" "$HOME/.claude/backups/settings.json.$TIMESTAMP.bak"
    echo "Backed up: $CLAUDE_SETTINGS -> $HOME/.claude/backups/settings.json.$TIMESTAMP.bak"
    jq --argjson allow "$allow_json" '.permissions.allow = $allow' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"
    mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
    echo "Merged: $CLAUDE_SETTINGS (permissions.allow)"
  fi
else
  mkdir -p "$HOME/.claude"
  jq -n --argjson allow "$allow_json" '{permissions: {allow: $allow}}' > "$CLAUDE_SETTINGS"
  echo "Created: $CLAUDE_SETTINGS (permissions.allow)"
fi

link_path "$CODEX_RULES" "$HOME/.codex/rules/my.rules" "$HOME/.codex/rules/backups"

echo "Done (env)."
