#!/usr/bin/env bash
# 個人マシン向けの一括インストール。3スクリプトを順に実行するだけのラッパー。
# 組織管理マシンでは env を除いた instructions / skills を個別に実行する。

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

"$SCRIPT_DIR/install-agents-instructions.sh"
"$SCRIPT_DIR/install-agents-skills.sh"
"$SCRIPT_DIR/install-agents-env.sh"

echo "Done."
