---
name: complete-the-change
description: A change is not done until all downstream artifacts (tests, docs, completions, configs, generated files) are updated in the same change — fix generated files at their source. Use when implementing features, changing CLIs/APIs/schemas, or touching anything with derived artifacts. 機能実装・CLI/API/スキーマ変更・生成物を持つ変更で必ず参照する。
---

# Complete the Change

変更の完全性。1つの変更に付随する成果物を同一変更内ですべて更新し、半端な完了を作らない。

## 付随成果物を同時に更新する

- 変更に付随する成果物(テスト・ドキュメント・型定義・設定・サンプル)を洗い出し、同一変更内で更新する
- 例: CLIコマンド追加なら、パーサ・ヘルプ・補完・ドキュメント・テストまで揃えて1つの変更とする
- 意図的に更新しない成果物があるなら、その理由を明記する(黙って省略しない)

## 生成物は生成元から直す

- 自動生成されるファイル(生成ドキュメント・コード生成物)は手編集しない。生成元を直して再生成する
- 生成元と生成物の乖離(drift)を見つけたら報告する

## 同種の箇所へ横展開する

- 1件の指摘・不具合を直したら、同種の箇所を横断して洗い出す(全部直すかは範囲を確認してから)
- 方針として決まった変更は該当する全対象に一度で適用する。1件だけ直して終わらない

## 禁止事項

- 生成物の手編集
- テスト・ドキュメント更新を「後で」に先送りした完了報告
- 付随成果物の更新漏れを黙って省略すること(やらないなら理由を書く)
- 指摘された1箇所だけ直して同種の箇所を放置すること
