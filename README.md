My dotfiles

## AI CLI 設定(Claude Code / Codex CLI 共通)

`agents/` を単一ソースとして、Claude Code と Codex CLI の両方が同じグローバル指示・skill・許可コマンドを参照する。

```
agents/
├── AGENTS.md         # 共通グローバル指示(skill索引は自動生成区間)
├── permissions.txt   # 許可コマンドprefixの単一ソース
└── skills/<name>/SKILL.md
```

### インストール(symlink)

実行はすべて `make` 経由(実体は `scripts/` 配下)。`make help` でターゲット一覧を表示する。すべて冪等で、既存の実体はタイムスタンプ付きで `~/.claude/backups/` / `~/.codex/backups/` へ退避される。

| ターゲット | 対象 | 組織管理マシン |
|---|---|---|
| `make instructions` | `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` → `agents/AGENTS.md` | 実行可 |
| `make skills` | `~/.claude/skills` → `agents/skills`、`~/.codex/skills/<name>` → `agents/skills/<name>`(skill単位。Codex同梱の `.system` を壊さないため) | 実行可 |
| `make env` | `~/.claude/settings.json` の `permissions.allow` マージ、`~/.codex/rules/my.rules` → `.codex/rules/my.rules` | 実行しない |

```sh
# 個人マシン: 一括(instructions + skills + env)
make install

# 組織管理マシン: 環境設定には触れず、個人用の指示とskillだけ入れる
make instructions skills
```

グローバル指示・skillの追加は組織設定に影響しない。一方 `~/.claude/settings.json` には組織・実機固有の設定が入るため、リンクせず `permissions.allow` キーのみマージ更新とし(env)、組織管理マシンでは env 自体を実行しない。

### 編集の流れ

- **グローバル指示・skill**: `agents/` 配下を直接編集すれば、symlink 経由で両CLIに即反映される(逆取り込みは不要)。skill を増やすときは `agents/skills/<name>/SKILL.md` を作る
- **許可コマンド**: `agents/permissions.txt` を編集して再生成する。生成先(`.codex/rules/my.rules`、`.claude/settings.json` の `permissions.allow`、`AGENTS.md` の skill 索引)は直接編集しない

```sh
make generate   # 冪等。編集後に実行し、差分を確認して commit
make env        # permissions.allow の実機へのマージを再実行
```

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
