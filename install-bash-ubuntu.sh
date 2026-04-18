#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/ubuntu/.bashrc"
TARGET_FILE="$HOME/.bashrc"
BACKUP_FILE="$HOME/.bashrc.bak"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

if [ -f "$TARGET_FILE" ]; then
  cp "$TARGET_FILE" "$BACKUP_FILE"
  echo "Backed up existing .bashrc to: $BACKUP_FILE"
fi

cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Installed Ubuntu .bashrc to: $TARGET_FILE"
echo "Source: $SOURCE_FILE"
