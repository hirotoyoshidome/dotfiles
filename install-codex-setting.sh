#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/.codex/rules/my.rules"
TARGET_DIR="$HOME/.codex/rules"
TARGET_FILE="$TARGET_DIR/my.rules"
BACKUP_DIR="$TARGET_DIR/backups"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR" "$BACKUP_DIR"

if [ -f "$TARGET_FILE" ]; then
  BACKUP_FILE="$BACKUP_DIR/my.rules.$TIMESTAMP.bak"
  cp "$TARGET_FILE" "$BACKUP_FILE"
  echo "Backed up existing file to: $BACKUP_FILE"
fi

cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Installed Codex rules to: $TARGET_FILE"
echo "Source: $SOURCE_FILE"
