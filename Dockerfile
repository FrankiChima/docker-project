FROM php:8.0.2-fpm

# The arguments defined in docker-compose.yml
ARG user
ARG uid

# To install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# To clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# To install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# To get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# To create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# To set working directory
WORKDIR /var/www

USER $user
