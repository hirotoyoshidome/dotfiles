---
name: git-workflow
description: Git operation rules for this user — staged-only commits, no unsolicited git actions, branch naming, and PR conventions. Use whenever a task involves git commit, branch, push, or pull request (PR) creation. コミット・ブランチ作成・push・PR作成を行うときに必ず参照する。
---

# Git Workflow

このユーザーのgit運用ルール。commit / branch / push / PR に関わる操作では必ず従うこと。

## 大原則: 指示されていないgit操作をしない

- commit・branch作成・push・PR作成は、**明示的に依頼されたときのみ**行う。作業が一段落しても勝手にコミットしない
- 「まだcommitしないでください」と言われたら、以降のターンでも依頼があるまでコミットしない

## コミット: staged の内容だけ

ユーザーは自分でstagingを管理している。「git stagedの内容でcommitして」が定型の依頼。

- **staged された内容だけ**をコミットする。`git add` を明示的に指示されない限り実行しない
- unstaged / untracked に関連しそうな変更が残っていても、勝手に add せず「〜がstagingされていないようです」と指摘するだけに留める
- コミットメッセージは簡潔に。`git log --oneline` で既存のトーンを確認して合わせる

### 例外: 大きい差分の段階レビュー

- 差分が大きいとき、ユーザーは「項目単位でstagedに載せる→ユーザーが目視→指示を受けてcommit」のループを回す。この運用をユーザーが依頼した(または合意した)場合に限り、AIが適切な単位で `git add` してよい
- この運用中も commit は引き続きユーザーの明示指示があるまで行わない
- 差分が大きくなりそうなときは、AI側からこの段階レビューを提案してよい。そもそも変更差分はできるだけ小さく保つ

## コミット・PRの粒度

- 1コミット=1関心事。依頼されたコミットが複数の関心事(実装 / 配線 / ドキュメント / テスト など)を含む場合は、分割を提案する
  - 例: store層の実装 → CLIへの配線 → ドキュメント → テスト、をそれぞれ別コミットにするスタイル
- PRは小さく焦点を絞る。大きな変更は小さいPR単位への分割を提案する
- PR本文は要点2〜5行で簡潔に。breaking change がある場合は必ず明記する

## ブランチ

- 命名は `feature/xxx` 形式が主。バグ修正は `fix/xxx`、ドキュメントのみの変更は `docs/xxx` も可
- ブランチ作成も依頼されたときのみ

## PR作成

`gh` CLI を使う。デフォルトの規約:

- **draft** で作成する
- 向き先は **master または派生元ブランチ**。どちらか不明瞭な場合は確認する
- **PR本文は日本語**で書く(タイトルも日本語で問題ない)
- 人手で必要な作業がある場合は、チェックリスト形式の独立セクションで書き、この PR の期待値(どうなれば成功か)を明記する

## AI支援の透明性

- AI支援で作成したコミットに `Co-authored-by:` トレーラーを付けるのは可
- ブランチ名・コミット件名・PRタイトルにAIツール名の飾り(`[AI]` 等)を付けない(明示指示がある場合を除く)

## 禁止事項

- 依頼されていない commit / branch作成 / push / PR作成 / タグ付け
- 明示指示のない `git add`(staged外の変更を勝手に含めること。段階レビュー運用に合意済みの場合のみ例外)
- `git reset --hard` / `push --force` など履歴を破壊する操作を確認なしで実行すること
- 複数の関心事が混ざったコミットを、分割の提案なしに作ること
