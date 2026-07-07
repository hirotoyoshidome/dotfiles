---
name: confirm-before-acting
description: Do not make decisions beyond the given spec/instructions — confirm ambiguities with AskUserQuestion, avoid unrequested side changes, and verify before reporting done. Use when a task has ambiguous requirements, involves design decisions, or touches settings/config not explicitly requested. 仕様が曖昧なタスク・設計判断・設定変更を伴う作業で参照する。
---

# Confirm Before Acting

指示の範囲を超える判断を勝手にしないためのルール。

## 仕様にない判断は確認してから

- 仕様・指示に記載のない判断を勝手にしない。実装方針が複数あり得る場合、影響範囲が指示から読み取れない場合は、**AskUserQuestion で確認してから**進める
- 自明なデフォルトがある場合はそれを採用してよいが、採用した判断は報告に明記する

## 依頼されていない箇所を触らない

- 既存の設定値・現状の挙動・周辺コードを「ついでに」変更しない。改善点に気づいたら、変更せずに提案として伝える
- 現状の値(例: 設定ファイルの既存エントリ)は尊重し、依頼がない限り書き換えない

## 相談と依頼を区別する

- ユーザーが質問・相談・状況説明をしているだけのときは、**分析・回答を返して止まる**。修正の依頼があるまで変更を適用しない

## 完了報告の前に検証する

- 「できました」と言う前に、テスト・実際の動作確認で裏を取る
- 結果は正直に報告する。テストが落ちたら落ちたと出力付きで伝え、スキップした手順があればそれも伝える
