---
name: reproducible-runbook
description: Write setup/operation docs as reproducible runbooks — copy-pasteable commands, CLI-first, and troubleshooting recorded as problem+solution pairs. Use when writing READMEs, setup guides, operational procedures, or recording troubleshooting. README・セットアップ手順・運用手順・トラブルシューティングの記録時に参照する。
---

# Reproducible Runbook

手順ドキュメントは「未来の自分がそのまま再現できる」形で書く。

## コマンド付きで再現可能に

- セットアップ・ビルド・実行・確認の手順は、コピペで通る実際のコマンドとして書く
- 手順は実際に実行して確認してから書く。未検証のコマンド例を載せない
- CLIで完結する手順を優先する(GUI手順は環境・バージョン依存で腐りやすい)

## トラブルシューティングは「躓き+解決」をセットで

- 遭遇した問題は「症状・原因・解決」をセットで記録する。解決だけ書かない(次に同じ症状を見たとき照合できない)
- 環境依存の前提(権限・グループ・接続設定など)は明記する

## 禁止事項

- 動作未確認のコマンド例の記載
- 解決策だけ書いて症状・原因を書かないトラブルシューティング記録
- 「よしなに設定する」のような再現不能な手順
