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

## ユーザーが実行するコマンド

- for ループや `$(...)` を使わず、名前・ARN・プロファイルなどの実値を埋めた1行ずつにする(途中で止まると漏れが出る)。実行済みの行も印を付けて残す
- 実行の後は読み取りで残りを確かめ、残っている分だけを出し直す

## 環境別の手順書

- 環境ごとに分けるときは、見出し・文面・順序をそろえ、違いはその環境でしか要らない箇所だけにする(書き終えたら diff で確かめる)
- 作業の時間帯など、まだ決まっていないことは書かない

## 禁止事項

- 動作未確認のコマンド例の記載
- 解決策だけ書いて症状・原因を書かないトラブルシューティング記録
- 「よしなに設定する」のような再現不能な手順
