#!/usr/bin/env bash
# agents/ 配下の単一ソースから、CLI別の設定ファイルを再生成する。
#   agents/permissions.txt      -> .codex/rules/my.rules
#                               -> .claude/settings.json の permissions.allow キー
#   agents/skills/*/SKILL.md    -> agents/AGENTS.md の SKILLS マーカー区間(skill索引)
# 冪等: 入力が同じなら何度実行しても出力は変わらない。

set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PERMISSIONS_FILE="$REPO_DIR/agents/permissions.txt"
SKILLS_DIR="$REPO_DIR/agents/skills"
AGENTS_MD="$REPO_DIR/agents/AGENTS.md"
CODEX_RULES="$REPO_DIR/.codex/rules/my.rules"
CLAUDE_SETTINGS="$REPO_DIR/.claude/settings.json"

for required in "$PERMISSIONS_FILE" "$AGENTS_MD" "$CLAUDE_SETTINGS"; do
  if [ ! -f "$required" ]; then
    echo "Required file not found: $required" >&2
    exit 1
  fi
done
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

# ---- .codex/rules/my.rules ----
awk 'NF && $0 !~ /^#/ {
  printf "prefix_rule(pattern=["
  for (i = 1; i <= NF; i++) printf "%s\"%s\"", (i > 1 ? ", " : ""), $i
  printf "], decision=\"allow\")\n"
}' "$PERMISSIONS_FILE" > "$CODEX_RULES.tmp"
mv "$CODEX_RULES.tmp" "$CODEX_RULES"
echo "Generated: $CODEX_RULES"

# ---- .claude/settings.json (permissions.allow キーのみ置換) ----
allow_json="$(awk 'NF && $0 !~ /^#/ { printf "Bash(%s:*)\n", $0 }' "$PERMISSIONS_FILE" | jq -R . | jq -s .)"
jq --argjson allow "$allow_json" '.permissions.allow = $allow' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
echo "Generated: $CLAUDE_SETTINGS (permissions.allow)"

# ---- agents/AGENTS.md の skill 索引 ----
INDEX_TMP="$(mktemp)"
trap 'rm -f "$INDEX_TMP"' EXIT
for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  name="$(basename "$(dirname "$skill_md")")"
  description="$(sed -n 's/^description:[[:space:]]*//p' "$skill_md" | head -1)"
  if [ -z "$description" ]; then
    echo "description not found in frontmatter: $skill_md" >&2
    exit 1
  fi
  printf -- '- **%s**: %s\n' "$name" "$description" >> "$INDEX_TMP"
done

awk -v idx="$INDEX_TMP" '
  /<!-- SKILLS:BEGIN/ {
    print
    while ((getline line < idx) > 0) print line
    close(idx)
    skip = 1
    next
  }
  /<!-- SKILLS:END/ { skip = 0 }
  !skip { print }
' "$AGENTS_MD" > "$AGENTS_MD.tmp"
mv "$AGENTS_MD.tmp" "$AGENTS_MD"
echo "Generated: $AGENTS_MD (skill index)"
