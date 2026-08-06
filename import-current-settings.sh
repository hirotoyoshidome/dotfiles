#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
APPLY=0

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--apply]

Import current local settings from HOME into this repository.

Options:
  --apply   Copy files into the repository. Without this option, only show diffs.
  -h, --help
            Show this help.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --apply)
      APPLY=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

show_diff() {
  source_path="$1"
  target_path="$2"

  if [ ! -e "$source_path" ]; then
    echo "warning: source not found, skipped: $source_path" >&2
    return 0
  fi

  if [ ! -e "$target_path" ]; then
    echo "new: $source_path -> $target_path"
    return 0
  fi

  if diff -qr "$target_path" "$source_path" >/dev/null; then
    echo "unchanged: $target_path"
    return 0
  fi

  echo "diff: $source_path -> $target_path"
  git diff --no-index -- "$target_path" "$source_path" || true
}

copy_path() {
  source_path="$1"
  target_path="$2"

  if [ ! -e "$source_path" ]; then
    echo "warning: source not found, skipped: $source_path" >&2
    return 0
  fi

  mkdir -p "$(dirname -- "$target_path")"

  if [ -d "$source_path" ]; then
    case "$target_path" in
      "$SCRIPT_DIR"/*)
        ;;
      *)
        echo "Refusing to replace directory outside repository: $target_path" >&2
        exit 1
        ;;
    esac
    rm -rf "$target_path"
    cp -Rp "$source_path" "$target_path"
  else
    cp -p "$source_path" "$target_path"
  fi

  echo "imported: $source_path -> $target_path"
}

process_path() {
  source_path="$1"
  target_path="$2"

  if [ "$APPLY" -eq 1 ]; then
    copy_path "$source_path" "$target_path"
  else
    show_diff "$source_path" "$target_path"
  fi
}

if [ "$APPLY" -eq 0 ]; then
  echo "Dry-run mode. Use --apply to import these settings."
fi

# Claude / Codex 関連(CLAUDE.md, skills, my.rules)は symlink 運用に移行したため
# 逆取り込みの対象外(リポジトリの agents/ を直接編集する)。
process_path "$HOME/.bash_profile" "$SCRIPT_DIR/mac/.bash_profile"
process_path "$HOME/.bashrc" "$SCRIPT_DIR/mac/.bashrc"
process_path "$HOME/.vimrc" "$SCRIPT_DIR/mac/.vimrc"

if [ "$APPLY" -eq 0 ]; then
  echo "Dry-run complete. No repository files were changed."
else
  echo "Import complete."
fi
