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

## ブランチ

- 命名は `feature/xxx` 形式
- ブランチ作成も依頼されたときのみ

## PR作成

`gh` CLI を使う。デフォルトの規約:

- **draft** で作成する
- 向き先は **master または派生元ブランチ**。どちらか不明瞭な場合は確認する
- **PR本文は日本語**で書く(タイトルも日本語で問題ない)
