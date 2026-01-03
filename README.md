# Mon SaaS Sport
[![PHP](https://img.shields.io/badge/PHP-8.2-blue.svg)](https://www.php.net/) 
[![Symfony](https://img.shields.io/badge/Symfony-7.4-purple.svg)](https://symfony.com/) 
[![Docker](https://img.shields.io/badge/Docker-Compose-lightblue.svg)](https://www.docker.com/)

Application web pour la gestion de clubs sportifs, développée avec **Symfony 7.4 WebApp** et conteneurisée avec **Docker**.

---

## ⚡ Fonctionnalités pour l'instant

- Projet Symfony 7.4 installé avec WebApp skeleton
- Docker configuré pour :
  - PHP 8.2
  - Nginx
  - MySQL
  - PhpMyAdmin
  - Mailpit (SMTP pour tests emails)
- Navigation vers `https://local.monsaassport.com/` fonctionne
- Symfony UX (Turbo + Stimulus) prêt à être utilisé
- AssetMapper activé pour la gestion des assets modernes

---

## 🐳 Prérequis

- [Docker & Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)
- [Symfony CLI](https://symfony.com/download) (optionnel mais recommandé)
- [Node.js / npm](https://nodejs.org/) (optionnel pour Tailwind ou JS futur)

---

## 🚀 Installation

1. **Cloner le projet**

```bash
git clone git@github.com:TonUtilisateur/mon-saas-sport.git
cd mon-saas-sport
```

2. **Démarrer les containers Docker**
   
```bash
docker compose up -d
```
Cela démarre : PHP, Nginx, MySQL, PhpMyAdmin, Mailpit.

3. Installer les dépendances PHP
   
```bash
docker compose exec php composer install
```

4. Créer la base de données (MySQL)
   
```bash
docker compose exec php bin/console doctrine:database:create
```
 
5. Vérifier que Symfony fonctionne

Ouvre ton navigateur sur :
https://local.monsaassport.com

🧰 Structure du projet
```csharp
mon-saas-sport/
├─ docker/                 # Config Docker (nginx, certs, php)
├─ public/                 # Point d'entrée Nginx / Symfony
├─ src/                    # Code source Symfony
├─ templates/              # Templates Twig
├─ var/                    # Cache et logs (gitignored)
├─ vendor/                 # Dépendances Composer (gitignored)
├─ docker-compose.yml      # Compose pour PHP / Nginx / DB / Mailpit
├─ Makefile (optionnel)    # Commandes pratiques (start, rebuild, bash)
├─ .env                    # Variables d'environnement (gitignored)
└─ README.md
```

📦 Dépendances importantes
- Symfony : Framework PHP 7.4.*
- Symfony UX : Turbo, Stimulus
- Symfony AssetMapper : gestion moderne des assets
- Doctrine ORM / Migrations : gestion DB
- MySQL : base de données principale
- Docker & Docker Compose : conteneurisation
- Mailpit : SMTP pour tests emails
- PhpMyAdmin : interface DB

⚙️ Commandes utiles
- Démarrer les containers : make start ou docker compose up -d
- Entrer dans PHP : make bash ou docker compose exec php bash
- Installer les dépendances Composer : make composer cmd="install"
- Symfony console : make console cmd="list"
- Arrêter les containers : make stop ou docker compose down

📌 Prochaines étapes
- Configurer l’authentification Symfony Security
- CRUD Membres / Équipes
- Multi-club / multi-domaine
- Pages publiques & modules activables
- Mise en place UX (Turbo + Stimulus) pour navigation SPA-like

📚 Liens utiles
- Symfony Documentation
- Docker Documentation
- Symfony UX Turbo
- Symfony Stimulus
