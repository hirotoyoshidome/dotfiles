# グローバル設定

## 言語

- 回答は常に日本語で書く
- PR本文・issue・コミット説明・ユーザー向けドキュメントも日本語で書く

## 基本方針(詳細は ~/.claude/skills/ の各skill参照)

- **git-workflow**: commit / branch / PR は明示的に依頼されたときのみ。コミットはstagedの内容だけ(勝手に `git add` しない)。PRはdraft・本文日本語
- **confirm-before-acting**: 仕様にない判断は勝手にせず AskUserQuestion で確認。依頼されていない箇所を「ついでに」変更しない
- **structural-fixes**: 既存の配置パターンに従う。対症療法ではなく構造的な解決を選ぶ。変更理由(なぜ)を必ず添える
