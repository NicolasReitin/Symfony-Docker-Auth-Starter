-include .env.local
-include .env
-include Makefile.crontab
export

.PHONY: help build up down restart logs shell composer npm yarn test

# Couleurs
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

# Variables avec valeurs par défaut si .env pas chargé
APP_DOMAIN ?= local.monsaassport.com
APP_URL ?= http://$(APP_DOMAIN)
MAILPIT_WEB_PORT ?= 8025
MAILPIT_ENABLE ?= true

# Variables
DOCKER_COMPOSE = docker compose -f docker-compose.yml
PHP_CONTAINER = php
DB_CONTAINER = db
EXEC_PHP = $(DOCKER_COMPOSE) exec php
EXEC_DB = $(DOCKER_COMPOSE) exec database

## —— Docker 🐳 ————————————————————————————————————————————————————————
build: ## Construire les images Docker
	@echo "${GREEN}Building Docker images...${RESET}"
	$(DOCKER_COMPOSE) build --pull --no-cache

build-fast: ## Construire les images Docker (sans cache clean)
	@echo "${GREEN}Building Docker images (fast)...${RESET}"
	$(DOCKER_COMPOSE) build

up: ## Démarrer tous les conteneurs
	@echo "${GREEN}Starting containers...${RESET}"
	$(DOCKER_COMPOSE) up -d --remove-orphans
	@echo "${GREEN}✓ Containers started!${RESET}"
	@echo ""
	@echo "${GREEN}📱 Application principale :${RESET}"
	@echo "${YELLOW}   $(APP_URL)${RESET}"
	@echo ""
	@echo "${YELLOW}⚠️  N'oubliez pas d'ajouter $(APP_DOMAIN) à votre fichier hosts !${RESET}"
	@echo ""
ifeq ($(MAILPIT_ENABLE),true)
	@echo "${YELLOW}   Mailpit (Emails) : http://$(APP_DOMAIN):$(MAILPIT_WEB_PORT)${RESET}"
endif
	@echo ""

down: ## Arrêter tous les conteneurs
	@echo "${YELLOW}Stopping containers...${RESET}"
	$(DOCKER_COMPOSE) down --remove-orphans

down-volumes: ## Arrêter et supprimer les volumes (⚠️ efface les données!)
	@echo "${YELLOW}Stopping containers and removing volumes...${RESET}"
	$(DOCKER_COMPOSE) down --remove-orphans --volumes

restart: down up ## Redémarrer tous les conteneurs

logs: ## Voir les logs de tous les conteneurs
	$(DOCKER_COMPOSE) logs -f

logs-php: ## Voir les logs du conteneur PHP
	$(DOCKER_COMPOSE) logs -f php

logs-db: ## Voir les logs du conteneur MySQL
	$(DOCKER_COMPOSE) logs -f database

ps: ## Liste des conteneurs en cours d'exécution
	$(DOCKER_COMPOSE) ps

## —— Info ℹ️  ——————————————————————————————————————————————————————————
info: ## Afficher la configuration actuelle
	@echo ""
	@echo "${GREEN}📋 Configuration actuelle :${RESET}"
	@echo ""
	@echo "${CYAN}Environnement :${RESET}"
	@echo "   APP_ENV         : ${YELLOW}$(APP_ENV)${RESET}"
	@echo "   APP_DEBUG       : ${YELLOW}$(APP_DEBUG)${RESET}"
	@echo ""
	@echo "${CYAN}URLs :${RESET}"
	@echo "   APP_DOMAIN      : ${YELLOW}$(APP_DOMAIN)${RESET}"
	@echo ""
	@echo "${CYAN}Ports :${RESET}"
	@echo "   Mailpit         : ${YELLOW}$(MAILPIT_WEB_PORT)${RESET}"
	@echo ""
	@echo "${CYAN}Services :${RESET}"
	@echo "   Mailpit         : ${YELLOW}$(MAILPIT_ENABLE)${RESET}"
	@echo ""

## —— Shell 💻 —————————————————————————————————————————————————————————
shell: ## Ouvrir un shell dans le conteneur PHP
	$(EXEC_PHP) sh

shell-root: ## Ouvrir un shell root dans le conteneur PHP
	$(DOCKER_COMPOSE) exec -u root php sh

db-shell: ## Ouvrir un shell MySQL
	$(EXEC_DB) mysql -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE)

## —— Composer 🎼 ——————————————————————————————————————————————————————
composer: ## Exécuter Composer (ex: make composer ARGS="require vendor/package")
	$(EXEC_PHP) composer $(ARGS)

composer-install: ## Installer les dépendances Composer
	$(EXEC_PHP) composer install --prefer-dist --no-progress

composer-update: ## Mettre à jour les dépendances Composer
	$(EXEC_PHP) composer update

composer-validate: ## Valider composer.json
	$(EXEC_PHP) composer validate --strict

## —— NPM/Yarn 📦 ——————————————————————————————————————————————————————
npm: ## Exécuter NPM (ex: make npm ARGS="install")
	$(EXEC_PHP) npm $(ARGS)

npm-install: ## Installer les dépendances NPM
	$(EXEC_PHP) npm install

npm-watch: ## Lancer Webpack Encore en mode watch
	$(EXEC_PHP) npm run watch

yarn: ## Exécuter Yarn (ex: make yarn ARGS="add package")
	$(EXEC_PHP) yarn $(ARGS)

yarn-install: ## Installer les dépendances Yarn
	$(EXEC_PHP) yarn install

yarn-watch: ## Lancer Webpack Encore en mode watch
	$(EXEC_PHP) yarn watch

yarn-build: ## Build les assets pour production
	$(EXEC_PHP) yarn build

## —— Symfony 🎶 ———————————————————————————————————————————————————————
sf: ## Exécuter une commande Symfony (ex: make sf ARGS="debug:router")
	$(EXEC_PHP) php bin/console $(ARGS)

cc: ## Vider le cache Symfony
	$(EXEC_PHP) php bin/console cache:clear

warmup: ## Préchauffer le cache
	$(EXEC_PHP) php bin/console cache:warmup

assets: ## Installer les assets
	$(EXEC_PHP) php bin/console assets:install public --symlink --relative

router: ## Afficher toutes les routes
	$(EXEC_PHP) php bin/console debug:router

## —— Database 🗄️ ——————————————————————————————————————————————————————
db-create: ## Créer la base de données
	$(EXEC_PHP) php bin/console doctrine:database:create --if-not-exists

db-drop: ## Supprimer la base de données (⚠️ dangereux!)
	$(EXEC_PHP) php bin/console doctrine:database:drop --force --if-exists

db-migrate: ## Exécuter les migrations
	$(EXEC_PHP) php bin/console doctrine:migrations:migrate --no-interaction

db-migration-generate: ## Générer une nouvelle migration
	$(EXEC_PHP) php bin/console doctrine:migrations:generate

db-migration-diff: ## Générer une migration basée sur les différences
	$(EXEC_PHP) php bin/console doctrine:migrations:diff

db-fixtures: ## Charger les fixtures (⚠️ écrase les données!)
	$(EXEC_PHP) php bin/console doctrine:fixtures:load --no-interaction

db-validate: ## Valider le mapping Doctrine
	$(EXEC_PHP) php bin/console doctrine:schema:validate

db-reset: db-drop db-create db-migrate db-fixtures ## Reset complet de la BDD

## —— Tests ✅ —————————————————————————————————————————————————————————
test: ## Lancer tous les tests
	$(EXEC_PHP) php bin/phpunit

test-unit: ## Lancer les tests unitaires
	$(EXEC_PHP) php bin/phpunit tests/Unit

test-integration: ## Lancer les tests d'intégration
	$(EXEC_PHP) php bin/phpunit tests/Integration

test-functional: ## Lancer les tests fonctionnels
	$(EXEC_PHP) php bin/phpunit tests/Functional

test-coverage: ## Générer le rapport de couverture
	$(EXEC_PHP) php bin/phpunit --coverage-html var/coverage

## —— Code Quality 🔍 ——————————————————————————————————————————————————
phpstan: ## Analyse statique avec PHPStan
	$(EXEC_PHP) vendor/bin/phpstan analyse src

cs-fixer: ## Fixer le code avec PHP-CS-Fixer
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix src

cs-fixer-dry: ## Vérifier le code sans le modifier
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix src --dry-run --diff

rector: ## Refactoring avec Rector
	$(EXEC_PHP) vendor/bin/rector process src

rector-dry: ## Vérifier les changements Rector sans les appliquer
	$(EXEC_PHP) vendor/bin/rector process src --dry-run

## —— Production 🚀 ————————————————————————————————————————————————————
deploy: ## Déployer en production (⚠️ utiliser avec précaution!)
	@echo "${YELLOW}Deploying to production...${RESET}"
	git pull origin main
	$(DOCKER_COMPOSE) build --no-cache
	$(DOCKER_COMPOSE) up -d
	$(EXEC_PHP) composer install --no-dev --optimize-autoloader
	$(EXEC_PHP) php bin/console cache:clear --env=prod
	$(EXEC_PHP) php bin/console cache:warmup --env=prod
	$(EXEC_PHP) php bin/console doctrine:migrations:migrate --no-interaction
	@echo "${GREEN}✓ Deployment complete!${RESET}"

## —— Backup & Restore 💾 ——————————————————————————————————————————————
backup-db: ## Backup de la base de données
	@echo "${YELLOW}Creating database backup...${RESET}"
	$(DOCKER_COMPOSE) exec -T database mysqldump -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) > backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "${GREEN}✓ Backup created!${RESET}"

restore-db: ## Restaurer la base de données (ex: make restore-db FILE=backup.sql)
	@echo "${YELLOW}Restoring database from $(FILE)...${RESET}"
	$(DOCKER_COMPOSE) exec -T database mysql -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) < $(FILE)
	@echo "${GREEN}✓ Database restored!${RESET}"

## —— Security 🔒 ——————————————————————————————————————————————————————
security-check: ## Vérifier les vulnérabilités des dépendances
	$(EXEC_PHP) composer audit

## —— Cleanup 🧹 ———————————————————————————————————————————————————————
clean: ## Nettoyer les fichiers temporaires
	@echo "${YELLOW}Cleaning temporary files...${RESET}"
	rm -rf var/cache/* var/log/* var/sessions/*
	@echo "${GREEN}✓ Cleaned!${RESET}"

prune: ## Nettoyer Docker (images, volumes inutilisés)
	docker system prune -a --volumes -f
