.DEFAULT_GOAL := help

.PHONY: help install instructions skills env generate bash-mac bash-ubuntu import import-apply

help: ## ターゲット一覧を表示
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "%-14s %s\n", $$1, $$2}'

install: ## AI CLI設定を一括インストール(個人マシン向け: instructions + skills + env)
	./scripts/install-agents-setting.sh

instructions: ## グローバル指示のみリンク(組織管理マシンでも実行可)
	./scripts/install-agents-instructions.sh

skills: ## skillsのみリンク(組織管理マシンでも実行可)
	./scripts/install-agents-skills.sh

env: ## 許可コマンド設定を反映(個人マシンのみ)
	./scripts/install-agents-env.sh

generate: ## permissions.txt / SKILL.md から生成物を再生成
	./scripts/generate-agents-assets.sh

bash-mac: ## mac用bash設定をインストール
	./scripts/install-bash-mac.sh

bash-ubuntu: ## ubuntu用bash設定をインストール
	./scripts/install-bash-ubuntu.sh

import: ## bash/vim設定の差分表示(取り込みは import-apply)
	./scripts/import-current-settings.sh

import-apply: ## bash/vim設定をリポジトリへ取り込み
	./scripts/import-current-settings.sh --apply
