---
name: deliverable-presentation
description: Put deliverables where humans actually look (repo-managed paths, not AI-only areas), state whether each file is for commit or temporary, lead with scannable tables/matrices before prose, and never use self-diminishing or negative wording in shared documents. Use when producing documents, reports, comparison/risk lists, or any file output. ドキュメント・レポート・比較表・リスク一覧などの成果物を出力するときに必ず参照する。
---

# Deliverable Presentation

成果物は「人間が気づける場所」に「一望できる形」で置く。内容が正しくても、見つからない・読み切れない成果物は存在しないのと同じ。

## 置き場所: 人間が普段見る場所に出す

- 長い成果物はチャットに垂れ流さず、ファイルに出力する
- 置き場所はリポジトリ管理下の、人間が普段開く場所(docs/ 等)。plans・scratchpad などのリポジトリ外・AI専用領域に置くと、ユーザーは存在に気づけない
- 出力のたびに「commit対象」か「一時ファイル(コミットしない)」かを明示する
- 判断・決定の記録は、その判断が効く場所の近く(設定ならその設定ファイルのコメント等)に残す

## 見せ方: まず一覧、詳細は後ろ

- 比較・条件分岐・課題・リスクの列挙は、散文ではなくまず表・マトリクスで一望できる形にする。詳細説明は表の後に置く
- リスクは定型で書く: 「何が起きたら困るか+それをどう検知するか+発生確率の見立て」
- 提示フォーマットに迷ったら、過去にユーザーが指定した定型(課題 / 詳細と制約 / 改善案(メリット・デメリット) / 廃案(理由付き))に寄せる

## 語彙: 成果物の言葉を選ぶ

- 「おまけ」「とりあえず」「一応」など、成果物を矮小化する・自信のない語を書かない。本当に不要なものなら消す。必要なものなら正当な理由を書く
- 共有ドキュメントでは、否定的・マイナスに読める表現を避ける(読者は書き手の事情を知らない)
- 特定の読者層を持ち上げる/見下すような区分表現(「人間向け」等)を使わない

## 禁止事項

- 長い成果物をチャット出力だけで終わらせること
- リポジトリ管理外・AI専用領域への成果物の配置(明示指示がある場合を除く)
- commit対象か一時ファイルかを言わずにファイルを作ること
- 比較・リスク・課題を散文の列挙だけで出すこと
- 「おまけ」「とりあえず」等の矮小化表現・共有ドキュメントでの否定的表現
