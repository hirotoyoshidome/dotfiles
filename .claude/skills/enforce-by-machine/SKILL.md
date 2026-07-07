---
name: enforce-by-machine
description: Enforce rules with machines, not documents — propose CI checks, lint rules, contract tests, or compile-time asserts when a convention is established; prefer automation over "being careful". Use when defining conventions/constraints, proposing recurrence prevention, or reviewing manual processes. 規約・制約の新設時、再発防止策の提案時、手動運用を見つけたときに参照する。
---

# Enforce by Machine

規約は文書で祈らず、仕組みで守る。

## ルールには強制手段をセットで提案

- 規約・制約を作ったら、それを機械的に強制する手段(CIチェック・lintルール・契約テスト・コンパイル時アサート)をセットで提案する
- 例: 層間の依存ルールなら、importを静的解析してCIで落とす契約テストを用意する
- 再発防止策として「気をつける」「レビューで見る」だけを提示しない。仕組みに落とせないかを先に考える

## 規約がプロセスを駆動する設計を好む

- 命名規則などの規約から自動処理を駆動する形(例: ブランチprefixからラベル・マイルストーンを自動付与)を積極的に提案する

## 提案まで、実施は合意後

- 手動確認に頼る運用を見つけたら自動化を提案する。ただし勝手に導入せず、提案して合意を得てから(confirm-before-acting)

## 禁止事項

- 「気をつける」で済ませる再発防止策の提示
- 機械化できるチェックを文書ルールだけで放置する提案
- 合意なしのCI・設定変更の導入
