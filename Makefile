# https://www.strangebuzz.com/fr/snippets/le-makefile-parfait-pour-symfony

# Misc
.ONESHELL:
.DEFAULT_GOAL = help
#.PHONY =

# Parameters
BACK_PORT = 55995
FRONT_PORT = 443
MAILCATCHER_PORT = 1080

# Executables
PHP = php
COMPOSER = composer
YARN = yarn
DOCKER = docker
DOCKER_COMPOSE = docker-compose
SYMFONY_BIN = symfony

USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-25s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m\n/'

## ——————————————————————————————— BACK ———————————————————————————————

## —— Composer 🧙️ —————————————————————————————————————————————————————

install: back/composer.lock  ## Install vendors according to the current composer.lock file
	@cd back
	@$(COMPOSER) install --no-progress --prefer-dist --optimize-autoloader

## —— Symfony 🎵️ ——————————————————————————————————————————————————————

migrate: ## Update datatable structure (require at least a migration created)
	@cd back
	@$(SYMFONY_BIN) console doctrine:migrations:migrate --no-interaction

reset-datatable: ## Delete and recreate datatable (require at least a migration created)
	@cd back
	@$(SYMFONY_BIN) console doctrine:database:drop --force
	@$(SYMFONY_BIN) console doctrine:database:create
	@$(SYMFONY_BIN) console doctrine:migrations:migrate --no-interaction

fixtures: ## Start fixtures (require DoctrineFixturesBundle)
	@cd back
	@$(SYMFONY_BIN) console doctrine:fixtures:load --no-interaction

keypair: ## Create keypair for SecurityBundle (require LexikJWTAuthenticationBundle)
	@cd back
	@$(SYMFONY_BIN) console lexik:jwt:generate-keypair

## —— RabbitMQ 🐇️ —————————————————————————————————————————————————————

consume: ## Consume all messages (require symfony/messenger)
	@cd back
	@$(SYMFONY_BIN) console messenger:consume -vv

open-rabbitmq-admin: ## Open RabbitMQ admin website (require rabbitmq in docker-compose)
	@cd back
	@$(SYMFONY_BIN) open:local:rabbitmq

## ——————————————————————————————— FRONT ——————————————————————————————

## —— Vite ⚡ —————————————————————————————————————————————————————————

yarn: front/yarn.lock ## Install node modules according to the current yarn.lock file
	@cd front
	@$(YARN)

## ——————————————————————————————— OTHER ——————————————————————————————

## —— Docker 🐳 ———————————————————————————————————————————————————————

up: ## Start the docker hub detached
	@$(DOCKER_COMPOSE) up --detach

up-with-logs: ## Start the docker hub with logs
	@$(DOCKER_COMPOSE) up

build: ## Builds the images
	@$(DOCKER_COMPOSE) build --pull --no-cache

down: ## Stop the docker hub
	@$(DOCKER_COMPOSE) down --remove-orphans

sh: ## Log to the docker container
	@$(DOCKER_COMPOSE) exec php sh

logs: ## Show live logs
	@$(DOCKER_COMPOSE) logs --tail=0 --follow

## —— Project 🐝 ——————————————————————————————————————————————————————

init: create-git-alias submodule-init checkout-master install yarn build ## Initialize project, need to run after git clone
	@echo "\n🎉 Done ! 🎉\n"
	@echo "Execute \"make start\" for launch all the environnement ! 🐳\n"
	@echo "Execute \"make stop\" when you are done in order to close the environment.\n"
	@echo "And \"make help\" for list all available commands."

start: up sleep open-all ## Start Docker

stop: down ## Stop Docker

open-react: ## Open the React app into browser
	@xdg-open 'https://localhost:$(FRONT_PORT)'

open-api: ## Open API Platform into browser
	@xdg-open 'https://localhost:$(BACK_PORT)/api/docs'

open-mailcatcher: ## Open Mailcatcher into browser
	@xdg-open 'http://localhost:$(MAILCATCHER_PORT)'

open-all: open-api open-react open-mailcatcher ## Open all links into browser

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

checkout-master: checkout-master-back checkout-master-front

checkout-master-back:
	@cd back
	@git checkout master

checkout-master-front:
	@cd front
	@git checkout master

## —— Other 🤷‍ ————————————————————————————————————————————————————————

sleep:
	@sleep 3
