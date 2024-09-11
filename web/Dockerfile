FROM php:8.3-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install and enable PHP extensions
RUN docker-php-ext-install \
    mbstring \
    pdo \
    pdo_mysql \
    xml \
    pdo_pgsql

# OpenSSL, PCRE, and Hash are already included in the base image

# Set the working directory
WORKDIR /var/www/html

# Copy the PHP files
COPY src/ .

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis
