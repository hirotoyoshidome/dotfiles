#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

exec "$SCRIPT_DIR/../scripts/import-current-settings.sh" "$@"
