#!/usr/bin/env bash
# agents/permissions-cases.txt の代表コマンドを、生成済みの .codex/rules/my.rules に対して
# codex execpolicy check で判定し、期待する判定と一致するか検証する。
# Claude 側には判定CLIがないため対象外(同じ permissions.txt から生成されるため線引きは揃う)。

set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CASES_FILE="$REPO_DIR/agents/permissions-cases.txt"
CODEX_RULES="$REPO_DIR/.codex/rules/my.rules"

for required in "$CASES_FILE" "$CODEX_RULES"; do
  if [ ! -f "$required" ]; then
    echo "Required file not found: $required" >&2
    exit 1
  fi
done
command -v codex >/dev/null || { echo "codex is required" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

total=0
failed=0
while read -r expected command_line; do
  case "$expected" in
    '' | '#'*) continue ;;
    allow | prompt | forbidden | none) ;;
    *)
      echo "Unknown expected decision: $expected $command_line" >&2
      exit 1
      ;;
  esac

  # コマンドは空白区切りのトークンとして渡す(クォート・glob展開は扱わない)。
  # stdin はケースファイルの読み込みに使っているため codex には渡さない。
  set -f
  # shellcheck disable=SC2086
  result="$(codex execpolicy check --rules "$CODEX_RULES" -- $command_line < /dev/null)"
  set +f
  # どのルールにも一致しない場合、出力に decision キーが無い
  actual="$(printf '%s' "$result" | jq -r '.decision // "none"')"

  total=$((total + 1))
  if [ "$actual" != "$expected" ]; then
    failed=$((failed + 1))
    echo "NG: $command_line (expected: $expected, actual: $actual)"
  fi
done < "$CASES_FILE"

if [ "$failed" -gt 0 ]; then
  echo "Failed: $failed / $total" >&2
  exit 1
fi
echo "OK: $total cases"
