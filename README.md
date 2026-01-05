# 🚀 Symfony Docker Auth Starter
[![PHP](https://img.shields.io/badge/PHP-8.2-blue.svg)](https://www.php.net/) 
[![Symfony](https://img.shields.io/badge/Symfony-7.4-purple.svg)](https://symfony.com/) 
[![Docker](https://img.shields.io/badge/Docker-Compose-lightblue.svg)](https://www.docker.com/)

Un starter kit Symfony moderne prêt à l'emploi, pensé pour démarrer rapidement des projets web avec une base saine : Docker, authentification, sécurité, Symfony UX.

Ce dépôt est volontairement générique, propre et réutilisable.

---

## 🎯 Objectif du projet

Fournir une **installation fraîche** (fresh install) de Symfony avec :

- ✅ Un environnement **Docker** prêt à l'emploi
- ✅ Une **authentification complète** :
  - Login / Logout
  - Reset password (mot de passe oublié)
- ✅ Une **entité User** de base
- ✅ Une configuration **Security** claire et extensible
- ✅ **Symfony UX** installé et prêt

**➡️ L'idée** : cloner, lancer, développer. Sans perdre de temps.

---

## 🧱 Stack technique

| Composant | Description |
|-----------|-------------|
| **PHP** | Via Docker |
| **Symfony** | Version LTS ou stable |
| **Docker** | Conteneurisation complète |
| **Symfony Security** | Authentification & autorisation |
| **Form Login** | Authenticator pré-configuré |
| **Doctrine ORM** | Gestion de base de données |
| **Symfony UX** | Composants UI modernes |
| **Twig** | Moteur de templates |

---

## 📦 Prérequis

Avant de commencer, assurez-vous d'avoir :

- ✅ **Docker**
- ✅ **Docker Compose**
- ✅ **Git**

> **Note** : Aucune installation PHP locale n'est requise 🐳

---

## ⚙️ Installation

### 1️⃣ Cloner le projet

```bash
git clone https://github.com/votre-username/symfony-docker-auth-starter.git
cd symfony-docker-auth-starter
```

### 2️⃣ Configuration des variables d'environnement

Copiez le fichier `.env.example` si nécessaire  en .env et l'adapter selon votre environnement :

```bash
cp .env .env.local
```

Adaptez les variables selon vos besoins :

```env
DATABASE_URL="mysql://app:!ChangeMe!@database:5432/app?serverVersion=16&charset=utf8"
APP_SECRET=votre_secret_unique
MAILER_DSN=null://null
```

### 3️⃣ Lancer l'environnement Docker

```bash
docker compose up -d --build
```

Les conteneurs suivants seront démarrés :

- 🐘 **PHP-FPM** (PHP 8.x)
- 🌐 **Nginx** (serveur web)
- 🗄️ **Mysql** (base de données)

### 4️⃣ Installer les dépendances Symfony

```bash
docker compose exec php composer install
# or
make composer-install
```
### 5️⃣ Créer et initialiser la base de données

```bash
# Créer la base de données
docker compose exec php php bin/console doctrine:database:create
# or
make db-create

# Appliquer les migrations
docker compose exec php php bin/console doctrine:migrations:migrate
# or
make db-migrate
```

### 6️⃣ Accéder à l'application

🎉 Votre application est maintenant accessible sur : **https://localhost**

---

## 🔐 Authentification incluse

Le projet embarque une authentification par formulaire prête à l'emploi :

- 🔑 **Login** (`/login`)
- 🚪 **Logout** (`/logout`)
- 🔄 **Reset password** (mot de passe oublié)
- 🔒 **Gestion de session** sécurisée
- 🛡️ **Protection CSRF**

### Entité `User`

L'entité User inclut :

```php
- email (unique, identifiant de connexion)
- password (hashé avec l'algorithme auto)
- roles (ROLE_USER par défaut)
```

Cette base est volontairement **minimale** pour rester flexible et adaptable à vos besoins.

### Créer votre premier utilisateur

```bash
# Générer un hash de mot de passe
docker compose exec php php bin/console security:hash-password

# Puis insérez l'utilisateur en base ou créez un système d'inscription
```

---

## 🛡️ Sécurité

### Configuration actuelle

- 📝 Configuration centralisée dans `config/packages/security.yaml`
- 🔐 Mots de passe hashés automatiquement
- 🎭 Accès protégé par rôles
- 🛡️ CSRF activé sur les formulaires
- 🔒 Sessions sécurisées

---

## 🎨 Symfony UX

Symfony UX est installé et prêt à l'emploi :

### Composants inclus

- ⚡ **Stimulus** : Contrôleurs JavaScript légers
- 🚀 **Turbo** : Navigation ultra-rapide
- 📦 **AssetMapper** ou **Webpack Encore** : Gestion des assets moderne

### Structure

```
assets/
├── app.js              # Point d'entrée JavaScript
├── styles/
│   └── app.css         # Styles globaux
└── controllers/        # Contrôleurs Stimulus
    └── hello_controller.js
```

Idéal pour des **interfaces réactives** sans basculer immédiatement sur un front full SPA.

---

## 📂 Structure du projet

```
.
├── config/
│   ├── packages/
│   │   └── security.yaml          # Configuration sécurité
│   └── routes.yaml
├── src/
│   ├── Controller/
│   │   └── SecurityController.php # Login/Logout
│   ├── Entity/
│   │   └── User.php               # Entité utilisateur
│   ├── Repository/
│   │   └── UserRepository.php
│   └── Security/
│       └── AppAuthenticator.php   # Authentificateur
├── templates/
│   ├── base.html.twig
│   └── security/
│       └── login.html.twig        # Page de connexion
├── docker-compose.yml              # Configuration Docker
├── Dockerfile
└── .env                            # Variables d'environnement
```

---

## 🛠️ Makefile - Commandes simplifiées

Ce projet inclut un **Makefile** complet pour simplifier toutes les opérations courantes. Plus besoin de taper de longues commandes Docker !

### 📋 Lister toutes les commandes disponibles

Voir fichier makefile à la racine du projet

---

## 🧪 Extensibilité & Évolutions possibles

Selon les besoins de votre projet, vous pouvez facilement ajouter :

### Tests

```bash
docker compose exec php composer require --dev phpunit/phpunit
docker compose exec php php bin/phpunit
```

### Qualité de code

```bash
# PHPStan
docker compose exec php composer require --dev phpstan/phpstan

# PHP CS Fixer
docker compose exec php composer require --dev friendsofphp/php-cs-fixer
```

### Fonctionnalités d'authentification avancées

```bash
# Formulaire d'inscription
docker compose exec php php bin/console make:registration-form

# Reset password
docker compose exec php php bin/console make:reset-password
```

---

## 🐛 Dépannage

### Les conteneurs ne démarrent pas

```bash
# Vérifier les logs
docker compose logs

# Reconstruire complètement
docker compose down -v
docker compose up -d --build
```

### Erreur de connexion à la base de données

Vérifiez que :
1. Le conteneur Mysql est bien démarré : `docker compose ps`
2. La variable `DATABASE_URL` dans `.env.local` est correcte
3. Le port 8080 n'est pas déjà utilisé sur votre machine

### Permission denied sur les fichiers

```bash
docker compose exec php chown -R www-data:www-data var/
docker compose exec php chmod -R 775 var/
```

### Le site est inaccessible

Vérifiez que :
- Les conteneurs tournent : `docker compose ps`
- Le port 8080 est libre
- Nginx est bien configuré

---


## 📞 Support

- 📧 **Email** : contact@nicolas-reitin.fr

---
