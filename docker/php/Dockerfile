FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs
