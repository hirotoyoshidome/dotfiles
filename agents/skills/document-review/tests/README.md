# document-review の回帰テスト

document-writing の「完成文書の条件」・`words.tsv`、document-review の `check-words.sh`・`SKILL.md` を変えたら、両方を実行する。

テストデータ(`words/`・`review/` 配下)はすべて架空の文書で、各ファイルの先頭にその旨を書く。文書(.md)には HTMLコメントで書く(読み手に表示されない部分なので、チェックの対象外)。期待結果のファイルには `#` で始まる行で書く(比較しない)。

## 語検出(自動)

```sh
make doc-check-test
```

`words/<name>.md` の出力を `words/<name>.expected` と比べる。語を足したら `words/ng.md` にその語を含む行を足し、期待結果を手で書いて `ng.expected` に追記する(実行結果をそのまま写さない)。

## 読解による判定(手動)

LLM の判定は実行ごとに揺れるので、自動では比べない。`review/` の各文書に対して document-review を明示的に起動し、`review/cases.tsv` と照らし合わせる。

```sh
# Claude Code(リポジトリのルートで)
/document-review agents/skills/document-review/tests/review/report-ng.md
# Codex
$document-review agents/skills/document-review/tests/review/report-ng.md
```

| 判定 | 合格の条件 |
|---|---|
| 問題を含む文書(`*-ng.md`) | `cases.tsv` の観点IDがすべて指摘される。ほかの観点IDが加わっても、該当箇所が実際に条件に反していれば合格 |
| 問題のない文書(`*-ok.md`) | 「指摘なし」になる |

条件を足したら、その条件に反する箇所を `*-ng.md` に足し、`cases.tsv` に観点IDを追記する。
