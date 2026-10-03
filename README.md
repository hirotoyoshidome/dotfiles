My dotfiles

## AI CLI 設定

`agents/` を単一ソースとして、グローバル指示・skill・許可コマンドを管理する。Codex CLI はスクリプトで常にこのリポジトリと同期させ、Claude Code は配置先のみ記載して手動で置く(実機に会社の設定が入ることがあり、スクリプトで上書き・マージしないため)。

```
agents/
├── AGENTS.md         # 共通グローバル指示(skill索引は自動生成区間)
├── permissions.txt         # 許可コマンドprefixの単一ソース(allow/prompt/forbidden)
├── permissions-cases.txt   # 許可コマンドの判定を検証する代表コマンド
└── skills/<name>/SKILL.md
```

### Codex CLI へのインストール

実行はすべて `make` 経由(実体は `scripts/` 配下)。`make help` でターゲット一覧を表示する。

```sh
make install
```

冪等で、既存の実体はタイムスタンプ付きで `~/.codex/backups/` / `~/.codex/rules/backups/` へ退避される。

| 配置先 | リポジトリ | 置き方 |
|---|---|---|
| `~/.codex/AGENTS.md` | `agents/AGENTS.md` | symlink |
| `~/.codex/skills/<name>` | `agents/skills/<name>` | symlink(skill単位。Codex同梱の `.system` を壊さないため。`SKILL.md` の無くなったリンクは外す) |
| `~/.codex/rules/my.rules` | `.codex/rules/my.rules` | コピー(Codex は symlink の `.rules` を読み込まないため) |

### Claude Code への配置(手動)

スクリプトでは配置しない。以下を手で置く。

| 配置先 | リポジトリ | 置き方 |
|---|---|---|
| `~/.claude/CLAUDE.md` | `agents/AGENTS.md` | symlink またはコピー |
| `~/.claude/skills/<name>` | `agents/skills/<name>` | symlink またはコピー |
| `~/.claude/settings.json` の `permissions.allow/ask/deny` | `.claude/settings.json` の同キー | 手でマージ(会社の設定など他のキーは残す) |

skill の一部は他の skill に依存する(各 SKILL.md の「依存する skill」の節)。skill を選んで置くときは、依存先も同じ階層に置く。

| skill | 依存先 |
|---|---|
| document-review | document-writing(条件と語の辞書を読む) |
| document-writing | document-review(提出前のチェックに使う) |
| concise-writing / deliverable-presentation | document-writing(条件を参照する) |

### 編集の流れ

- **グローバル指示・skill**: `agents/` 配下を直接編集すれば、symlink 経由で Codex に即反映される(逆取り込みは不要)。skill を増やすときは `agents/skills/<name>/SKILL.md` を作り、`make install` でリンクする
- **許可コマンド**: `agents/permissions.txt` を編集して再生成する。生成先(`.codex/rules/my.rules`、`.claude/settings.json` の `permissions.allow/ask/deny`、`AGENTS.md` の skill 索引)は直接編集しない
- **文書の条件**: 完成文書の条件の正本は `agents/skills/document-writing/SKILL.md` の「完成文書の条件」の節、語の辞書は同じディレクトリの `words.tsv`。他の skill には書かず、ここを参照させる。変えたら `document-review` の回帰テストを回す(手順は `agents/skills/document-review/tests/README.md`)

```sh
make generate            # 冪等。編集後に実行し、差分を確認して commit
make permissions-check   # 代表コマンドの判定が期待どおりか検証(codex が必要)
make doc-check-test      # 文書チェックの語検出の回帰テスト
make install             # my.rules はコピーのため、生成後は毎回実行する
```

#### 許可コマンドの線引き

`permissions.txt` はセクションで判定を書き分ける。複数一致したときは厳しい判定が勝つため、広く `[allow]` したうえで危険な形だけを `[prompt]` / `[forbidden]` で上書きする。

| セクション | Codex (`my.rules`) | Claude (`settings.json`) | 用途 |
|---|---|---|---|
| `[allow]` | `allow` | `allow` | 読み取り、git/gh の日常操作、ビルド・テスト系 |
| `[prompt]` | `prompt` | `ask` | 取り消せない操作(`reset --hard`、`branch -D` 等)、`gh api` |
| `[forbidden]` | `forbidden` | `deny` | force push、リポジトリ・issue の削除 |

- Codex の `allow` はサンドボックス外で確認なしに実行される。そのため `rm`・`curl`・汎用インタプリタ(`bash -c` 等)・`npx`・`docker run` など、許可すると実質全許可になるものは載せない
- 判定は前方一致のため、オプションを引数の後ろに置いた形(`git push origin main --force`)は捕捉できない
- 線引きを変えたら `permissions-cases.txt` に許可・拒否の両側のケースを足す
- Codex で「常に許可」を選ぶと `~/.codex/rules/default.rules` に一回限りのルールが溜まる。汎用化できるものは `permissions.txt` へ取り込み、`default.rules` は退避して空に戻す。`default.rules` は承認ルール専用で、生成したルールは置かない

##### トラブルシューティング

- **問題**: Codex で許可済みのはずのコマンドに毎回確認が出る
  - **解決**: リダイレクト・`$(...)`・`$'...'` などを含むシェル文は、分割されずに全体が 1 コマンドとして判定される。PR 本文などは `--body-file` のようにファイル経由で渡す。`codex execpolicy check --pretty --rules .codex/rules/my.rules -- <command>` で実際の判定を確認できる
- **問題**: `permissions.txt` を変えたのに Codex の判定が変わらない
  - **解決**: `make install` を実行していないか、`default.rules` に古いルールが残っている(複数一致では厳しい判定が勝つため、`allow` を外しても `default.rules` 側の `allow` が効く)。実機に置かれたファイルでの判定は次で確認する

    ```sh
    codex execpolicy check --pretty --rules ~/.codex/rules/my.rules --rules ~/.codex/rules/default.rules -- <command>
    ```

## macOS

### Install settings to this PC

```sh
make bash-mac
```

### Import current PC settings into this repository

bash / vim の設定のみが対象(AI CLI 設定はリポジトリを単一ソースとするため対象外)。

```sh
make import        # 差分表示のみ
make import-apply  # リポジトリへ取り込み
```

- `~/.bash_profile` -> `mac/.bash_profile`
- `~/.bashrc` -> `mac/.bashrc`
- `~/.vimrc` -> `mac/.vimrc`

`mac/sync.sh` is kept as a compatibility wrapper and runs the same import script.

Codex and Claude history, auth files, cache files, and sqlite files are not imported.
