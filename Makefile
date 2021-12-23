# Misc
.ONESHELL:
.DEFAULT_GOAL = help
.PHONY = help init composer-install yarn create-git-alias submodule-init

# Executables
EXEC_PHP = php

# Alias
SYMFONY = $(EXEC_PHP) bin/console
YARN = yarn

# Executables: local only
SYMFONY_BIN = symfony

## ————————————————————————————— MOST USED ————————————————————————————

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-10s\033[0m %s\n\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

init: create-git-alias submodule-init composer-install yarn ## To run after clone project

## ——————————————————————————————— BACK ———————————————————————————————

## —— Composer 🧙️ —————————————————————————————————————————————————————

composer-install: back/vendor ## Install vendors according to the current composer.lock file

back/composer.lock: back/composer.json
	@cd back && $(SYMFONY_BIN) composer update --no-progress --prefer-dist --optimize-autoloader

back/vendor: back/composer.lock
	@cd back && $(SYMFONY_BIN) composer install --no-progress --prefer-dist --optimize-autoloader

## ——————————————————————————————— FRONT ——————————————————————————————


## —— Vite ⚡ —————————————————————————————————————————————————————————

yarn: front/node_modules ## Install node modules according to the current yarn.lock file

front/yarn.lock: front/package.json
	@cd front && $(YARN)

front/node_modules: front/yarn.lock
	@cd front && $(YARN)

## ——————————————————————————————— OTHER ——————————————————————————————

create-git-alias:
	@git config alias.sdiff '!'"git diff && git submodule foreach 'git diff'"
	@git config alias.spush 'push --recurse-submodules=on-demand'
	@git config alias.supdate 'submodule update --remote --merge'

submodule-init:
	@if find back -prune -empty | grep -q .
	then
		@if find front -prune -empty | grep -q .
		then
			@git submodule update --init
		fi
	fi
