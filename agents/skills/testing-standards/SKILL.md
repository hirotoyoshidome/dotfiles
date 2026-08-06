---
name: testing-standards
description: Test quality standards — cover success/failure/boundary/cleanup paths, always add regression tests for bug fixes, and never swallow errors. Use when writing or modifying tests, fixing bugs, or writing error handling. テスト作成・バグ修正・エラーハンドリング実装時に必ず参照する。
---

# Testing Standards

テストとエラー処理の品質基準。品質は人力レビューではなくテストとルールで担保する、というユーザーの方針。

## テスト観点

- 正常系・異常系(期待したエラーが返るか)・境界値を揃える
- リソースの解放・クリーンアップも検証対象。失敗パスでリークしないか(失敗注入でクリーンアップ経路を通す発想)まで見る
- 通ることだけが目的の、アサーションの弱いテストを書かない

## バグ修正には回帰テスト

- バグ修正には必ず回帰テストを付ける。先に再現テストを書けるなら先に書く(red→green)
- テストなしでバグ修正の完了を報告しない

## エラーを握りつぶさない

- silent catch・空のcatchブロック・「ログだけ出して継続」を書かない
- エラーを汎用型(anyerror相当)に丸めない。ドメイン境界で意味のあるエラーに変換し、低レベルのエラーを上位に漏らさない
- エラーパスにもクリーンアップ責務がある(errdefer相当の後始末を忘れない)

## ログは運用で読める形に

- 例外のハンドリングは ERROR 以上のレベルで記録し、原因を特定できる情報を本文(message)に入れる。構造化フィールドだけに逃がして本文を空洞にしない
- ログレベルは一般的な意味論(DEBUG=開発用 / INFO=記録すべき正常系 / ERROR=利用者に支障)に従う。異常系を DEBUG/INFO に落とさない
- レベルや文言だけ直さない。それを生んだ構造(広すぎる catch・下流での握り潰し)まで遡って直す

## 配置は既存の流儀に従う

- テストの置き場所・命名・スタイルはプロジェクトの既存パターンを確認して合わせる(structural-fixes と同じ原則)

## 禁止事項

- テストなしのバグ修正完了報告
- エラーの握りつぶし(silent catch・空catch)
- 例外を INFO 以下のレベルで記録すること
- 期待エラーの検証がない「正常系だけ」のテスト追加
- テストを通すためだけの実装側の特別分岐
