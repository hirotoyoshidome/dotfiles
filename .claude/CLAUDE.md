# グローバル設定

## 言語

- 回答は常に日本語で書く
- PR本文・issue・コミット説明・ユーザー向けドキュメントも日本語で書く

## 基本方針(詳細は ~/.claude/skills/ の各skill参照)

- **git-workflow**: commit / branch / PR は明示的に依頼されたときのみ。コミットはstagedの内容だけ(勝手に `git add` しない)。PRはdraft・本文日本語
- **confirm-before-acting**: 仕様にない判断は勝手にせず AskUserQuestion で確認。依頼されていない箇所を「ついでに」変更しない
- **design-first**: 非自明なタスクはいきなり実装せず、設計を提示して合意してから
- **preserve-reasoning**: 「なぜ」を必ず残す。不採用案も理由付きで記録。ユーザーの検討履歴を消さない
- **structural-fixes**: 構造的解決・既存パターン踏襲・過剰抽象の忌避
- **testing-standards**: テスト観点の網羅・エラー握りつぶし禁止
- **complete-the-change**: 付随成果物(テスト・docs・生成物)まで含めて1つの変更
- **enforce-by-machine**: ルールは文書でなく仕組み(CI/lint/契約テスト)で強制
- **scope-boundaries**: Non-goals・やらないことの明示
- **express-intent**: 型・命名で意図を表現
- **reproducible-runbook**: 再現可能なコマンド付き手順ドキュメント
- **rules-evolution**: 同じ指摘が2回でルールへの昇格を提案
