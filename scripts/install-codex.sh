#!/usr/bin/env bash
# Codex CLI へリポジトリの設定を配置する。冪等で、既存の実体はタイムスタンプ付きで退避する。
#   ~/.codex/AGENTS.md        -> agents/AGENTS.md
#   ~/.codex/skills/<name>    -> agents/skills/<name>  (skill単位。同梱の .system を壊さないため)
#   ~/.codex/rules/my.rules   <- .codex/rules/my.rules のコピー
#                                (Codex は symlink の .rules を読み込まないため)
# Claude Code は会社の設定が入ることがあるため対象外(README の手動配置を参照)。

set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
AGENTS_MD="$REPO_DIR/agents/AGENTS.md"
SKILLS_DIR="$REPO_DIR/agents/skills"
CODEX_RULES="$REPO_DIR/.codex/rules/my.rules"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

for required in "$AGENTS_MD" "$SKILLS_DIR" "$CODEX_RULES"; do
  if [ ! -e "$required" ]; then
    echo "Required path not found: $required" >&2
    exit 1
  fi
done

# backup_path <target> <backup_dir>: target を backup_dir へ退避する
backup_path() {
  target_path="$1"
  backup_dir="$2"

  mkdir -p "$backup_dir"
  backup_file="$backup_dir/$(basename -- "$target_path").$TIMESTAMP.bak"
  mv "$target_path" "$backup_file"
  echo "Backed up: $target_path -> $backup_file"
}

# link_path <source> <target> <backup_dir>
# target が既に正しいリンクなら何もしない。実体が存在すれば backup_dir へ退避してからリンクする。
link_path() {
  source_path="$1"
  target_path="$2"
  backup_dir="$3"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    echo "ok (already linked): $target_path"
    return 0
  fi

  mkdir -p "$(dirname -- "$target_path")"
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path "$target_path" "$backup_dir"
  fi

  ln -s "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
}

# copy_file <source> <target> <backup_dir>
# target が source と同一内容の通常ファイルなら何もしない。それ以外(symlink含む)は退避してからコピーする。
copy_file() {
  source_path="$1"
  target_path="$2"
  backup_dir="$3"

  if [ -f "$target_path" ] && [ ! -L "$target_path" ] && cmp -s "$source_path" "$target_path"; then
    echo "ok (already copied): $target_path"
    return 0
  fi

  mkdir -p "$(dirname -- "$target_path")"
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path "$target_path" "$backup_dir"
  fi

  cp "$source_path" "$target_path"
  echo "Copied: $source_path -> $target_path"
}

link_path "$AGENTS_MD" "$HOME/.codex/AGENTS.md" "$HOME/.codex/backups"

# SKILL.md を持つディレクトリだけを skill として扱う(generate-agents-assets.sh の索引と同じ条件)
for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  skill_dir="$(dirname -- "$skill_md")"
  link_path "$skill_dir" "$HOME/.codex/skills/$(basename -- "$skill_dir")" "$HOME/.codex/backups"
done

# リポジトリを指すリンクのうち、skill でなくなったもの(削除済み・SKILL.md 無し)を外す
for installed in "$HOME/.codex/skills"/*; do
  [ -L "$installed" ] || continue
  case "$(readlink "$installed")" in
    "$SKILLS_DIR"/*)
      if [ ! -f "$installed/SKILL.md" ]; then
        rm "$installed"
        echo "Removed stale link: $installed"
      fi
      ;;
  esac
done

copy_file "$CODEX_RULES" "$HOME/.codex/rules/my.rules" "$HOME/.codex/rules/backups"

echo "Done (codex)."
