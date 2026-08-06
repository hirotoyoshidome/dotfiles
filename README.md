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

用途別に3スクリプトに分かれている。すべて冪等で、既存の実体はタイムスタンプ付きで `~/.claude/backups/` / `~/.codex/backups/` へ退避される。

| スクリプト | 対象 | 組織管理マシン |
|---|---|---|
| `install-agents-instructions.sh` | `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` → `agents/AGENTS.md` | 実行可 |
| `install-agents-skills.sh` | `~/.claude/skills` → `agents/skills`、`~/.codex/skills/<name>` → `agents/skills/<name>`(skill単位。Codex同梱の `.system` を壊さないため) | 実行可 |
| `install-agents-env.sh` | `~/.claude/settings.json` の `permissions.allow` マージ、`~/.codex/rules/my.rules` → `.codex/rules/my.rules` | 実行しない |

```sh
# 個人マシン: 一括(3本を順に実行するラッパー)
./install-agents-setting.sh

# 組織管理マシン: 環境設定には触れず、個人用の指示とskillだけ入れる
./install-agents-instructions.sh
./install-agents-skills.sh
```

グローバル指示・skillの追加は組織設定に影響しない。一方 `~/.claude/settings.json` には組織・実機固有の設定が入るため、リンクせず `permissions.allow` キーのみマージ更新とし(env)、組織管理マシンでは env 自体を実行しない。

### 編集の流れ

- **グローバル指示・skill**: `agents/` 配下を直接編集すれば、symlink 経由で両CLIに即反映される(逆取り込みは不要)。skill を増やすときは `agents/skills/<name>/SKILL.md` を作る
- **許可コマンド**: `agents/permissions.txt` を編集して再生成する。生成先(`.codex/rules/my.rules`、`.claude/settings.json` の `permissions.allow`、`AGENTS.md` の skill 索引)は直接編集しない

```sh
./generate-agents-assets.sh   # 冪等。編集後に実行し、差分を確認して commit
./install-agents-env.sh       # permissions.allow の実機へのマージを再実行
```

## macOS

### Install settings to this PC

```sh
./install-bash-mac.sh
```

### Import current PC settings into this repository

bash / vim の設定のみが対象(AI CLI 設定は symlink 運用のため対象外)。

```sh
./import-current-settings.sh          # 差分表示のみ
./import-current-settings.sh --apply  # リポジトリへ取り込み
```

- `~/.bash_profile` -> `mac/.bash_profile`
- `~/.bashrc` -> `mac/.bashrc`
- `~/.vimrc` -> `mac/.vimrc`

`mac/sync.sh` is kept as a compatibility wrapper and runs the same import script.

Codex and Claude history, auth files, cache files, and sqlite files are not imported.
