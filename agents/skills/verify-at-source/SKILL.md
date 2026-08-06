---
name: verify-at-source
description: Settle facts from primary sources — read upstream source code and official docs to determine behavior, instead of stopping at "needs runtime verification". Use when investigating behavior or choosing approaches. 挙動調査・方式選定・「要実機確認」と書きそうなときに必ず参照する。
---

# Verify at Source

読めば確定できるものを「要確認」に残さない。推測や保守的な既定値ではなく一次情報で確定させる。

## 上流ソースを読む

- 調査を単一リポジトリに閉じない。依存先・上流のソースが参照可能なら読んで挙動を静的に確定する
- 「実機で叩かないと不明」と安易に決めつけない。ユーザーに「ソースからチェックすればいい」と言わせない

## 前提は一次情報で確定する

- サポート範囲・バージョン・プラン制約・機能提供条件は公式の一次情報を確認して断定する。ユーザーに調べ直させない
- 確定できないものは「未確認」と明示し、何を確認すれば確定するかを添える

## 選択肢は標準機構の棚卸しから

- 解決策を出す前に、そのプロトコル・フレームワークが標準で持つ機構を洗い出す。ユーザーが他所から代替案を持ち込む状態は選択肢出しの不足

## 禁止事項

- 参照可能なソース・一次情報があるのに「要実機確認」「要検証」で止めること
- 推測やライブラリ既定値を確認済みの事実のように書くこと
- 案の成否を左右する前提を未確認のまま推奨を出すこと
