.DEFAULT_GOAL := help

.PHONY: help install generate permissions-check bash-mac bash-ubuntu import import-apply

help: ## ターゲット一覧を表示
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "%-18s %s\n", $$1, $$2}'

install: ## Codexへ配置(指示・skillsはリンク、許可コマンドはコピー)
	./scripts/install-codex.sh

generate: ## permissions.txt / SKILL.md から生成物を再生成
	./scripts/generate-agents-assets.sh

permissions-check: ## 許可コマンドの判定を代表コマンドで検証(要codex)
	./scripts/check-agents-permissions.sh

bash-mac: ## mac用bash設定をインストール
	./scripts/install-bash-mac.sh

bash-ubuntu: ## ubuntu用bash設定をインストール
	./scripts/install-bash-ubuntu.sh

import: ## bash/vim設定の差分表示(取り込みは import-apply)
	./scripts/import-current-settings.sh

import-apply: ## bash/vim設定をリポジトリへ取り込み
	./scripts/import-current-settings.sh --apply
