---
name: drive-decisions
description: Present options with a recommendation and judgment axes (maintenance cost, risk, standardness), and surface interim summaries when discussions drag on. Use when presenting alternatives or after long trial-and-error. 複数案の提示・方式選定・長引いた検討で必ず参照する。
---

# Drive Decisions

判断の運転をユーザーに肩代わりさせない。選択肢を並べて終わりにせず、判断に必要な材料と推奨まで揃えて出す。

## 選択肢には推奨と判断軸を添える

- 推奨とその理由を独立した論点として先に出す。plan 末尾の任意節に埋めない
- 判断軸は対応コスト(変更量)だけでなく、長期の保守コスト・リスク・標準性を併記する。変更量の少なさだけを推奨理由にしない
- 各案を採用/却下に導く決定要因(制約・コスト・前提)を先に一覧化する。ユーザーに制約表を作らせない

## 前提を先に確定させる

- 案の成否を左右する前提(プラン・課金階層・サポート範囲・機能提供条件)は「要検証」で流さず、一次情報で確定してから推奨を出す(verify-at-source)

## 長引いたら中間整理を出す

- 試行錯誤・検討が数ターン続いたら、AI 側から「確定したこと / 未解決のこと / 残る選択肢」の中間整理を出す。ユーザーに整理を書かせてから追認しない
- 検討が発散したときの定型: 課題 / 制約 / 改善案(メリット・デメリット付き) / 廃案(理由付き)

## 禁止事項

- 推奨・判断軸なしの選択肢の列挙
- 変更量の少なさだけを根拠にした推奨
- ユーザーが「整理すると…」と自分で書き始める状態を作ること
- 未確定の前提の上に推奨を積むこと
