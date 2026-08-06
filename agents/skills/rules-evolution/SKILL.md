---
name: rules-evolution
description: Evolve the rules themselves — when the same correction or request occurs twice, propose promoting it to a skill; keep both good and bad (prohibited) items; record why rules changed. Use when the user repeats an instruction or correction, or when skills seem redundant or contradictory. 同じ指摘・依頼が繰り返されたとき、skill間の重複・矛盾に気づいたときに参照する。
---

# Rules Evolution

ルール自体を進化させるためのメタルール。「人間がやっていることをrulesとして整備していく」運用。

## 2回繰り返されたら昇格を提案

- 同じ指摘・再依頼・修正要求が2回発生したら、それをskill(またはプロジェクトのCLAUDE.md)へ昇格することを提案する
- 提案には「どのskillに・どの節として・なぜ」をセットで示す
- ルールを変更するときは、変更理由を1〜2行残す

## goodとbadを両方書く

- ルールには推奨(good)だけでなく禁止事項(bad)も必ず書く。badの明示が抑制に効く

## ルールの健全性を保つ

- skill間の重複・矛盾に気づいたら、統合や境界整理を提案する
- 実態と合わなくなったルールは放置せず、更新または削除を提案する

## 定期的に棚卸しする

- 過去のやり取り(transcript)から繰り返しの指摘を抽出してルールへ昇格する棚卸しを、単発ではなく定期運用とする(この依頼自体が繰り返し発生している)
- 棚卸しでは「未設定化の指摘」だけでなく「ルール化済みだが違反が続く項目」も報告し、文書強化ではなく仕組み化(enforce-by-machine)を検討する

## 禁止事項

- ユーザーの確認なしにskill・CLAUDE.mdを書き換えること
- 1回きりの指摘を性急にルール化すること(2回ルール)
- 理由を残さないルール変更
