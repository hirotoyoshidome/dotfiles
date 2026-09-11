#!/usr/bin/env bash
# agents/ 配下の単一ソースから、CLI別の設定ファイルを再生成する。
#   agents/permissions.txt      -> .codex/rules/my.rules
#                               -> .claude/settings.json の permissions.allow/ask/deny キー
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

# ---- permissions.txt の解析 ----
# 「<section>\t<prefix>」の行へ正規化する。section は Codex の decision 名(allow/prompt/forbidden)。
# セクション見出しより前のコマンド行・未知のセクションはエラー。
PERMISSION_ENTRIES="$(awk '
  /^[[:space:]]*(#|$)/ { next }
  /^\[.*\]$/ {
    section = substr($0, 2, length($0) - 2)
    if (section != "allow" && section != "prompt" && section != "forbidden") {
      printf "Unknown section at line %d: %s\n", NR, $0 > "/dev/stderr"
      exit 1
    }
    next
  }
  section == "" {
    printf "Command before any section at line %d: %s\n", NR, $0 > "/dev/stderr"
    exit 1
  }
  { $1 = $1; printf "%s\t%s\n", section, $0 }
' "$PERMISSIONS_FILE")"

# ---- .codex/rules/my.rules ----
{
  echo "# 生成物: agents/permissions.txt から scripts/generate-agents-assets.sh が生成する。直接編集しないこと。"
  printf '%s\n' "$PERMISSION_ENTRIES" | awk -F'\t' '{
    n = split($2, tokens, " ")
    printf "prefix_rule(pattern=["
    for (i = 1; i <= n; i++) printf "%s\"%s\"", (i > 1 ? ", " : ""), tokens[i]
    printf "], decision=\"%s\")\n", $1
  }'
} > "$CODEX_RULES.tmp"
mv "$CODEX_RULES.tmp" "$CODEX_RULES"
echo "Generated: $CODEX_RULES"

# ---- .claude/settings.json (permissions.allow/ask/deny キーのみ置換) ----
# claude_rules_json <section>: 指定セクションの prefix を Claude の Bash ルール配列(JSON)にする
claude_rules_json() {
  printf '%s\n' "$PERMISSION_ENTRIES" \
    | awk -F'\t' -v section="$1" '$1 == section { printf "Bash(%s:*)\n", $2 }' \
    | jq -R . | jq -s .
}
jq --argjson allow "$(claude_rules_json allow)" \
   --argjson ask "$(claude_rules_json prompt)" \
   --argjson deny "$(claude_rules_json forbidden)" \
   '.permissions.allow = $allow | .permissions.ask = $ask | .permissions.deny = $deny' \
   "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
echo "Generated: $CLAUDE_SETTINGS (permissions.allow/ask/deny)"

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
