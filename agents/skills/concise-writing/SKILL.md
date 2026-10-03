---
name: concise-writing
description: Keep natural-language writing to the essence — concise without losing information; never narrate background history or code details in prose. Use when writing code comments, docs, reports, or PR bodies. コードコメント・ドキュメント・報告・PR本文の執筆時に必ず参照する。
---

# Concise Writing

自然言語を書きすぎない。文章は量が増えるほど読まれなくなる。ただし簡潔にしすぎて情報量が失われるのは本末転倒。

## 依存する skill

- document-writing: 恒久ドキュメントの条件(SKILL.md の「完成文書の条件」の節)

## 本質を捉えた範囲だけ書く

- 書く前に「これは読者の判断・行動を変える情報か」で選別する
- 過去の背景・経緯・ソースコードの詳細は散文化しない。コードと履歴(git/PR)が語るものを文章で再説明しない
- 事実の列挙ではなく要点の整理にする。レビューできない長さは成果物として失敗

## コードコメント

- コメントには「現在の選択の理由」だけを書く。変更の経緯・過去案の履歴を積み上げない(履歴は PR・ドキュメント側)
- コードを読めば分かることをコメントで繰り返さない

## 恒久ドキュメント

- 読み手が誰か(AI 向け / 人間向け)で情報の要否を決める
- 経緯・逸話の焼き込み、増減する件数、曖昧語の条件は document-writing の「完成文書の条件」に従う

## preserve-reasoning との線引き

- 判断ログ(なぜその案か・不採用理由)は残す対象。ただし 1〜2 行で簡潔に
- 消す対象は説明の冗長さ・経緯の物語。残す対象は判断の根拠。両者を混同しない

## 禁止事項

- 背景・経緯・実装詳細の散文化(コード・履歴で分かるものの再説明)
- 判断に効かない情報で文章量を膨らませること
- 簡潔化を理由に判断ログ・制約・代替手段の存在を無言で削ること(preserve-reasoning 違反)
