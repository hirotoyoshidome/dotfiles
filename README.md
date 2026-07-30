My dotfiles

## macOS

### Install settings to this PC

Repository settings can be installed into the home directory with these scripts.
Existing files are backed up by each install script before replacement.

```sh
./install-bash-mac.sh
./install-codex-setting.sh
./install-claude-setting.sh
```

### Import current PC settings into this repository

First, check the differences without changing repository files.

```sh
./import-current-settings.sh
```

If the differences are correct, import them into the repository.

```sh
./import-current-settings.sh --apply
```

`mac/sync.sh` is kept as a compatibility wrapper and runs the same import script.

```sh
./mac/sync.sh
./mac/sync.sh --apply
```

The import script only handles files that this repository already manages:

- `~/.bash_profile` -> `mac/.bash_profile`
- `~/.bashrc` -> `mac/.bashrc`
- `~/.vimrc` -> `mac/.vimrc`
- `~/.codex/rules/my.rules` -> `.codex/rules/my.rules`
- `~/.claude/settings.local.json` -> `.claude/settings.json`
- `~/.claude/CLAUDE.md` -> `.claude/CLAUDE.md`
- `~/.claude/skills/<existing skill>` -> `.claude/skills/<existing skill>`

Codex and Claude history, auth files, cache files, and sqlite files are not imported.
