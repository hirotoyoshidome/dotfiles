---
name: express-intent
description: Express intent through types and names — design types that carry meaning, avoid nullable overuse and catch-all names (util/common/core), and document contracts at public boundaries. Use when designing types/APIs, naming modules/functions/files, or reviewing code. 型・API設計、モジュール/関数/ファイルの命名、コードレビュー時に参照する。
---

# Express Intent

型と命名で意図を表現する。読むだけで意味・責務・契約が分かるコードを書く。

## 型が意味を持つように設計する

- 状態の違いは型で区別する(enum・union・専用型)。「とりあえずnullable」の多用は保守コストを上げるので避ける
- 不正な状態を型レベルで表現不可能にできないか、を先に考える

## 命名は責務を正確に

- `util` / `common` / `core` / `helper` / `misc` のようなcatch-allバケット名を作らない。行き場のないコードは命名でごまかさず配置を再考する
- `save` のような曖昧な動詞を避け、何をどう永続化・変更するのかが分かる名前にする(`update` は対象フィールドの粒度まで意識)

## 公開境界には契約を明記

- 公開API・pub関数には、所有権・寿命・返し得るエラー・呼び出し側の責務を、読むだけで分かる形で明記する(doc comment等)

## 設定・変数も意図を表現する

- 設定は意味の直交する軸で設計する。既存変数の語義を濁すオーバーロードより、意味の独立した新変数を選ぶ
- 分岐しない値・取りえない選択肢を設定項目にしない(常に同じ値にしかならない変数は消す)
- 必須の設定値に暗黙のフォールバックを置かない。未設定は fail-fast させる
- 環境間でブレてはいけない値を環境変数にしない。共通設定として固定する

## 禁止事項

- catch-all命名(util / common / core / helper 等)の新設
- 意図の読めないbool引数・マジックナンバーの放置
- 型で状態を区別できる場面でnullableに逃げる安易な設計
- 必須設定への暗黙フォールバック
- 機能しない(分岐先のない)設定値の新設
