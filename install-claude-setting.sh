#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/.claude/settings.json"
TARGET_DIR="$HOME/.claude"
TARGET_FILE="$TARGET_DIR/settings.local.json"
BACKUP_DIR="$TARGET_DIR/backups"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR" "$BACKUP_DIR"

if [ -f "$TARGET_FILE" ]; then
  BACKUP_FILE="$BACKUP_DIR/settings.local.json.$TIMESTAMP.bak"
  cp "$TARGET_FILE" "$BACKUP_FILE"
  echo "Backed up existing file to: $BACKUP_FILE"
fi

cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Installed Claude settings to: $TARGET_FILE"
echo "Source: $SOURCE_FILE"
