---
name: deliverable-presentation
description: Put deliverables where humans actually look (repo-managed paths, not AI-only areas), state whether each file is for commit or temporary, lead with scannable tables/matrices before prose, and never use self-diminishing or negative wording in shared documents. Use when producing documents, reports, comparison/risk lists, or any file output. ドキュメント・レポート・比較表・リスク一覧などの成果物を出力するときに必ず参照する。
---

# Deliverable Presentation

成果物は「人間が気づける場所」に「一望できる形」で置く。内容が正しくても、見つからない・読み切れない成果物は存在しないのと同じ。

## 依存する skill

- document-writing: 見せ方と語彙の条件(SKILL.md の「完成文書の条件」の節)

## 置き場所: 人間が普段見る場所に出す

- 長い成果物はチャットに垂れ流さず、ファイルに出力する
- 置き場所はリポジトリ管理下の、人間が普段開く場所(docs/ 等)。plans・scratchpad などのリポジトリ外・AI専用領域に置くと、ユーザーは存在に気づけない
- 出力のたびに「commit対象」か「一時ファイル(コミットしない)」かを明示する(チャットで伝える。資料の本文には書かない)
- 判断・決定の記録は、その判断が効く場所の近く(設定ならその設定ファイルのコメント等)に残す

## 見せ方と語彙

- 表で一望する形・リスクの定型・矮小化する語・否定的な表現・読者層の区分表現の条件は、document-writing の「完成文書の条件」に従う
- 提示フォーマットに迷ったら、過去にユーザーが指定した定型(課題 / 詳細と制約 / 改善案(メリット・デメリット) / 廃案(理由付き))に寄せる

## 禁止事項

- 長い成果物をチャット出力だけで終わらせること
- リポジトリ管理外・AI専用領域への成果物の配置(明示指示がある場合を除く)
- commit対象か一時ファイルかを言わずにファイルを作ること
