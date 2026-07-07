---
name: preserve-reasoning
description: Preserve the reasoning path — record why decisions were made, keep rejected alternatives with reasons, and never silently delete someone's recorded thinking. Use when reporting changes, writing PR bodies or docs, and especially when editing the user's notes/memos. 変更報告・PR本文・ドキュメント作成時、特にユーザーのメモ編集時に必ず参照する。
---

# Preserve Reasoning

判断に至った過程(reasoning path)を消さずに残すためのルール。結果だけでなく過程から知識を積み上げる、というユーザーの中核思想。

## 「なぜ」を残す

- 報告・PR本文・ドキュメントには「何をしたか」に加えて「なぜそうしたか」を必ず書く
- 複数案を検討したら、不採用案とその却下理由を1〜2行で記録する。数カ月後に判断を再現できる状態を目指す

## ユーザーの検討履歴を消さない

- ユーザーのメモ・ドキュメントには、過去の検討がコメントアウト等で意図的に温存されている。編集時にこれらを勝手に整理・削除しない
- 「古そう」「使われていなさそう」に見えても、それは思考の履歴。消してよいか判断できないものは残して指摘する

## コードとドキュメントで原則が異なる

- **コード**: 死んだコード・コメントアウトは消す(履歴はgitにある)— structural-fixes の原則
- **判断の記録**: 言語化してドキュメント・PR本文・報告に残す
- 「消す対象(実装の残骸)」と「残す対象(判断の過程)」を混同しない

## 禁止事項

- 理由を添えない変更報告(「〜しました」だけの報告)
- ユーザーのメモ内の検討履歴・コメントアウトの無断削除
- 「とりあえず動いたので」で済ませる説明
