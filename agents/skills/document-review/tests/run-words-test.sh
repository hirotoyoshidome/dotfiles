#!/usr/bin/env bash
# check-words.sh の回帰テスト。words/<name>.md の出力を words/<name>.expected と比べる。
# expected の # で始まる行(テストデータである旨の注記)は比較しない。
# 比較対象の行がなければ終了コード 0、あれば 1 を期待する。

set -eu

TESTS_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
CHECK="$TESTS_DIR/../check-words.sh"
failed=0

cd "$TESTS_DIR/words"
for doc in *.md; do
  expected="${doc%.md}.expected"
  if [ ! -f "$expected" ]; then
    echo "FAIL $doc: $expected がない" >&2
    failed=1
    continue
  fi

  # grep の終了コード 1 は「比較対象の行なし」なので許す
  want="$(grep -v '^#' "$expected" || [ $? -eq 1 ])"
  status=0
  actual="$("$CHECK" "$doc")" || status=$?
  if [ -n "$want" ]; then want_status=1; else want_status=0; fi

  if [ "$status" -ne "$want_status" ]; then
    echo "FAIL $doc: 終了コード $status (期待値 $want_status)" >&2
    failed=1
  fi
  if ! diff -u --label "$expected" --label actual <(printf '%s' "$want${want:+$'\n'}") <(printf '%s' "$actual${actual:+$'\n'}") >&2; then
    echo "FAIL $doc: 出力が期待値と異なる" >&2
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi
echo "ok: check-words.sh"
