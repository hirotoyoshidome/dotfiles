My dotfiles

## AI CLI 設定(Claude Code / Codex CLI 共通)

`agents/` を単一ソースとして、Claude Code と Codex CLI の両方が同じグローバル指示・skill・許可コマンドを参照する。

```
agents/
├── AGENTS.md         # 共通グローバル指示(skill索引は自動生成区間)
├── permissions.txt         # 許可コマンドprefixの単一ソース(allow/prompt/forbidden)
├── permissions-cases.txt   # 許可コマンドの判定を検証する代表コマンド
└── skills/<name>/SKILL.md
```

### インストール(symlink)

実行はすべて `make` 経由(実体は `scripts/` 配下)。`make help` でターゲット一覧を表示する。すべて冪等で、既存の実体はタイムスタンプ付きで `~/.claude/backups/` / `~/.codex/backups/` へ退避される。

| ターゲット | 対象 | 組織管理マシン |
|---|---|---|
| `make instructions` | `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` → `agents/AGENTS.md` | 実行可 |
| `make skills` | `~/.claude/skills` → `agents/skills`、`~/.codex/skills/<name>` → `agents/skills/<name>`(skill単位。Codex同梱の `.system` を壊さないため) | 実行可 |
| `make env` | `~/.claude/settings.json` の `permissions.allow/ask/deny` マージ、`~/.codex/rules/my.rules` → `.codex/rules/my.rules` | 実行しない |

```sh
# 個人マシン: 一括(instructions + skills + env)
make install

# 組織管理マシン: 環境設定には触れず、個人用の指示とskillだけ入れる
make instructions skills
```

グローバル指示・skillの追加は組織設定に影響しない。一方 `~/.claude/settings.json` には組織・実機固有の設定が入るため、リンクせず `permissions.allow/ask/deny` キーのみマージ更新とし(env)、組織管理マシンでは env 自体を実行しない。

### 編集の流れ

- **グローバル指示・skill**: `agents/` 配下を直接編集すれば、symlink 経由で両CLIに即反映される(逆取り込みは不要)。skill を増やすときは `agents/skills/<name>/SKILL.md` を作る
- **許可コマンド**: `agents/permissions.txt` を編集して再生成する。生成先(`.codex/rules/my.rules`、`.claude/settings.json` の `permissions.allow/ask/deny`、`AGENTS.md` の skill 索引)は直接編集しない

```sh
make generate            # 冪等。編集後に実行し、差分を確認して commit
make permissions-check   # 代表コマンドの判定が期待どおりか検証(codex が必要)
make env                 # permissions.allow/ask/deny の実機へのマージを再実行
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
- Codex で「常に許可」を選ぶと `~/.codex/rules/default.rules` に一回限りのルールが溜まる。汎用化できるものは `permissions.txt` へ取り込み、`default.rules` は退避して空に戻す

##### トラブルシューティング

- **問題**: Codex で許可済みのはずのコマンドに毎回確認が出る
  - **解決**: リダイレクト・`$(...)`・`$'...'` などを含むシェル文は、分割されずに全体が 1 コマンドとして判定される。PR 本文などは `--body-file` のようにファイル経由で渡す。`codex execpolicy check --pretty --rules .codex/rules/my.rules -- <command>` で実際の判定を確認できる

## macOS

### Install settings to this PC

```sh
make bash-mac
```

### Import current PC settings into this repository

bash / vim の設定のみが対象(AI CLI 設定は symlink 運用のため対象外)。

```sh
make import        # 差分表示のみ
make import-apply  # リポジトリへ取り込み
```

- `~/.bash_profile` -> `mac/.bash_profile`
- `~/.bashrc` -> `mac/.bashrc`
- `~/.vimrc` -> `mac/.vimrc`

`mac/sync.sh` is kept as a compatibility wrapper and runs the same import script.

Codex and Claude history, auth files, cache files, and sqlite files are not imported.
