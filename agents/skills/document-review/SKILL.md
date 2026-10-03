---
name: document-review
description: Check a finished document against the "完成文書の条件" section of document-writing before submitting — machine word checks plus a review by a fresh-context subagent that has not seen the conversation — and report findings only, without editing. Use after finishing a document file that others will read (before submitting or reporting it), and when the user asks to check a document or a report posted in chat. 他者が読む文書をファイルに書き終えたとき(提出・報告の前)、およびユーザーが文書やチャットの報告のチェックを依頼したときに必ず参照する。
---

# Document Review

提出前の文書を、document-writing の「完成文書の条件」に照らしてチェックし、指摘だけを返す。文書は修正しない。

## 依存する skill

- document-writing: 条件の正本(SKILL.md の「完成文書の条件」の節)と、語の辞書(`words.tsv`)を読む。この skill と同じ階層に置く

パスの起点は、この SKILL.md があるディレクトリ(Claude Code では `${CLAUDE_SKILL_DIR}`)。

- 条件: `../document-writing/SKILL.md` の「完成文書の条件」の節
- 語の辞書: `../document-writing/words.tsv`
- 語検出: `check-words.sh`

## 対象

- ファイルに書いた、他者が読む文書: 書き終えたら、提出・報告の前に毎回チェックする
- チャットに出した報告: ユーザーが依頼したときだけチェックする
- HTMLコメント(`<!-- -->`)は読み手に表示されないので、どちらの判定でも対象外

## 手順

### 1. 対象を確定する

- 書き終えたファイル、または引数のファイルを対象にする(複数可)
- チャットの報告が対象なら、その報告を一時ファイル(scratchpad などリポジトリ外)へ書き出して対象にする。書き出すときに内容を変えない
- どれが対象か判断できなければ聞く

### 2. 語を検出する

```sh
bash <skillのディレクトリ>/check-words.sh <対象ファイル>...
```

- 終了コード 0 は検出なし、1 は検出あり。2 は引数・辞書の不備なので、エラー内容を報告して止まる

### 3. 会話を知らない読み手に判定させる

会話を引き継がないサブエージェントを1つ起動する(Claude Code は Agent ツール、Codex は `spawn_agent` を `fork_context` なしで使う)。プロンプトは次の文面だけにし、パスだけを絶対パスに置き換える。文書の背景・経緯・意図は渡さない(渡すと「読み手は会話を知らない」の検証にならない)。

```
次の文書を、条件ファイルの「完成文書の条件」の節のうち、判定が「読解」または「語・読解」の項目に照らしてチェックしてください。
- 文書: <対象ファイルの絶対パス>
- 条件ファイル: <document-writing の SKILL.md の絶対パス>

あなたはこの文書が書かれた経緯を知りません。文書だけを読んで判定してください。
- 条件の項目に当てはまるものだけを指摘する。項目外の改善提案や好みの指摘はしない
- HTMLコメント(<!-- -->)は読み手に表示されないので対象外
- 語の機械検出は別に行うので、words.tsv にある語そのものは指摘しない
- 修正後の文面は書かない。直し方を添えるなら1行まで
- 出力は次の表だけ。該当がなければ「指摘なし」とだけ書く

| 該当箇所(行番号と引用) | 観点ID | 理由 |
|---|---|---|
```

### 4. 結果をまとめる

- 2 と 3 の結果を「該当箇所 / 観点ID / 理由」の1つの表にし、文書の先頭から順に並べる
- 同じ箇所が同じ観点で両方に挙がったら1行にまとめる
- 条件にない観点IDの指摘は表に入れず、表の後に「観点外の指摘 N 件」とだけ書く(求められたら中身を出す)
- 指摘がなければ「指摘なし」と書く
- 修正はしない。直すかはユーザーが決める。直すときは document-writing の「修正は差分で行う」に従う

## 禁止事項

- チェックのついでに文書を修正すること
- サブエージェントに文書の背景・経緯・意図を渡すこと
- 条件にない観点の指摘を表に混ぜること
- check-words.sh のエラー(終了コード 2)を無視して続けること
