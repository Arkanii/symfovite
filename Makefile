# https://www.strangebuzz.com/fr/snippets/le-makefile-parfait-pour-symfony

# Misc
.ONESHELL:
.DEFAULT_GOAL = help
#.PHONY =

# Parameters
BACK_PORT = 8000
FRONT_PORT = 3000

# Executables
PHP = php
COMPOSER = composer
YARN = yarn
DOCKER = docker
DOCKER_COMPOSE = docker-compose

USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)

# Alias
SYMFONY = $(PHP) bin/console

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-18s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m\n/'

## ——————————————————————————————— BACK ———————————————————————————————

## —— Composer 🧙️ —————————————————————————————————————————————————————

install: back/composer.lock ## Install vendors according to the current composer.lock file
	@cd back && $(COMPOSER) install --no-progress --prefer-dist --optimize-autoloader

## ——————————————————————————————— FRONT ——————————————————————————————


## —— Vite ⚡ —————————————————————————————————————————————————————————

yarn: front/yarn.lock ## Install node modules according to the current yarn.lock file
	@cd front && $(YARN)

## ——————————————————————————————— OTHER ——————————————————————————————

## —— Docker 🐳 ———————————————————————————————————————————————————————

up: ## Start the docker hub
	$(DOCKER_COMPOSE) up --detach

up-no-detach: ## Start the docker hub
	$(DOCKER_COMPOSE) up

build: ## Builds the images
	$(DOCKER_COMPOSE) build --pull --no-cache

down: ## Stop the docker hub
	$(DOCKER_COMPOSE) down --remove-orphans

sh: ## Log to the docker container
	@$(DOCKER_COMPOSE) exec php sh

logs: ## Show live logs
	@$(DOCKER_COMPOSE) logs --tail=0 --follow

#chown:
#	@$(DOCKER_COMPOSE) run --rm database chown -R $(USER_ID):$(GROUP_ID) /var/lib/postgresql/data
#	@$(DOCKER_COMPOSE) run --rm php chown -R $(USER_ID):$(GROUP_ID) .
#	@$(DOCKER_COMPOSE) run --rm vite chown -R $(USER_ID):$(GROUP_ID) .

## —— Project 🐝 ——————————————————————————————————————————————————————

init: create-git-alias submodule-init checkout-master install yarn build ## Initialize project, need to run after git clone

start: up open-browser ## Start Docker

stop: down ## Stop Docker

open-browser: ## Open link into browser
	@sleep 3
	@xdg-open 'https://localhost'

## —— GIT 🚀 ——————————————————————————————————————————————————————————

create-git-alias: ## Create git alias about submodules
	@git config alias.sdiff '!'"git diff && git submodule foreach 'git diff'"
	@git config alias.spush 'push --recurse-submodules=on-demand'
	@git config alias.supdate 'submodule update --remote --merge'

submodule-init: ## Clone submodules if not already done
	@if find back -prune -empty | grep -q .
	then
		@if find front -prune -empty | grep -q .
		then
			@git submodule update --init
		fi
	fi

checkout-master:
	@cd back && git checkout master
	@cd front && git checkout master
