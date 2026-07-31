#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# SOURCE_FILE="$SCRIPT_DIR/.claude/settings.json"
TARGET_DIR="$HOME/.claude"

# TODO: settings.local.json として配置すると、そのディレクトリで Claude を起動したときに、有効になる。全体に有効にする場合は、settings.json として配置する必要がある。
# TARGET_FILE="$TARGET_DIR/settings.local.json"
BACKUP_DIR="$TARGET_DIR/backups"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

# if [ ! -f "$SOURCE_FILE" ]; then
#   echo "Source file not found: $SOURCE_FILE" >&2
#   exit 1
# fi

mkdir -p "$TARGET_DIR" "$BACKUP_DIR"

# if [ -f "$TARGET_FILE" ]; then
#   BACKUP_FILE="$BACKUP_DIR/settings.local.json.$TIMESTAMP.bak"
#   cp "$TARGET_FILE" "$BACKUP_FILE"
#   echo "Backed up existing file to: $BACKUP_FILE"
# fi

# cp "$SOURCE_FILE" "$TARGET_FILE"

# echo "Installed Claude settings to: $TARGET_FILE"
# echo "Source: $SOURCE_FILE"

# CLAUDE.md (global instructions)
SOURCE_CLAUDE_MD="$SCRIPT_DIR/.claude/CLAUDE.md"
TARGET_CLAUDE_MD="$TARGET_DIR/CLAUDE.md"

if [ -f "$SOURCE_CLAUDE_MD" ]; then
  if [ -f "$TARGET_CLAUDE_MD" ]; then
    BACKUP_FILE="$BACKUP_DIR/CLAUDE.md.$TIMESTAMP.bak"
    cp "$TARGET_CLAUDE_MD" "$BACKUP_FILE"
    echo "Backed up existing file to: $BACKUP_FILE"
  fi
  cp "$SOURCE_CLAUDE_MD" "$TARGET_CLAUDE_MD"
  echo "Installed Claude global instructions to: $TARGET_CLAUDE_MD"
fi

# Skills
SOURCE_SKILLS_DIR="$SCRIPT_DIR/.claude/skills"
TARGET_SKILLS_DIR="$TARGET_DIR/skills"

if [ -d "$SOURCE_SKILLS_DIR" ]; then
  mkdir -p "$TARGET_SKILLS_DIR"
  for skill_dir in "$SOURCE_SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    target_skill_dir="$TARGET_SKILLS_DIR/$skill_name"
    if [ -d "$target_skill_dir" ]; then
      backup_skill_dir="$BACKUP_DIR/skills-$skill_name.$TIMESTAMP.bak"
      cp -R "$target_skill_dir" "$backup_skill_dir"
      echo "Backed up existing skill to: $backup_skill_dir"
      rm -rf "$target_skill_dir"
    fi
    cp -R "$skill_dir" "$target_skill_dir"
    echo "Installed skill: $skill_name -> $target_skill_dir"
  done
fi
