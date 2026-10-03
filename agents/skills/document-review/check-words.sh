#!/usr/bin/env bash
# 文書から、document-writing/words.tsv の語を行番号つきで検出する。
# コードブロック(``` / ~~~)・インラインコード・HTMLコメント(<!-- -->)は対象外。
# 辞書は document-writing skill が持つため、同 skill を同じ階層に置く必要がある。
#   使い方: check-words.sh <file>...
#   出力:   <file>:<行>: 「<語>」 [<観点ID>] <理由>
#   終了コード: 0 検出なし / 1 検出あり / 2 引数・辞書の不備

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
WORDS="$SCRIPT_DIR/../document-writing/words.tsv"

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <file>..." >&2
  exit 2
fi
if [ ! -f "$WORDS" ]; then
  echo "words dictionary not found: $WORDS (document-writing skill を同じ階層に置く)" >&2
  exit 2
fi
for target in "$@"; do
  if [ ! -f "$target" ]; then
    echo "file not found: $target" >&2
    exit 2
  fi
done

awk -F '\t' '
  FNR == NR {
    if ($0 ~ /^#/ || $0 ~ /^[[:space:]]*$/) next
    if (NF != 3) { printf "invalid dictionary line %d: %s\n", FNR, $0 > "/dev/stderr"; bad = 1; exit 2 }
    n++; word[n] = $1; id[n] = $2; reason[n] = $3
    next
  }
  FNR == 1 { in_fence = 0; in_comment = 0 }
  {
    line = $0
    # 前の行から続く HTML コメントの終わりまでを除く
    if (in_comment) {
      e = index(line, "-->")
      if (e == 0) next
      line = substr(line, e + 3)
      in_comment = 0
    } else if (line ~ /^[[:space:]]*(```|~~~)/) {
      in_fence = !in_fence
      next
    }
    if (in_fence) next
    # 行内の HTML コメントを除く。閉じていなければ次の行へ持ち越す
    while ((s = index(line, "<!--")) > 0) {
      rest = substr(line, s + 4)
      e = index(rest, "-->")
      if (e == 0) { line = substr(line, 1, s - 1); in_comment = 1; break }
      line = substr(line, 1, s - 1) substr(rest, e + 3)
    }
    gsub(/`[^`]*`/, "", line)
    for (i = 1; i <= n; i++) {
      if (index(line, word[i]) > 0) {
        printf "%s:%d: 「%s」 [%s] %s\n", FILENAME, FNR, word[i], id[i], reason[i]
        found = 1
      }
    }
  }
  END {
    if (bad) exit 2
    exit found ? 1 : 0
  }
' "$WORDS" "$@"
