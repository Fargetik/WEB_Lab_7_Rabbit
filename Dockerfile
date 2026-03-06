FROM php:8.2-fpm

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    librdkafka-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений
RUN docker-php-ext-install sockets pdo_mysql \
    && pecl install rdkafka \
    && docker-php-ext-enable rdkafka sockets

# Установка Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

WORKDIR /var/www/html

# Копирование composer.json
COPY composer.json /var/www/html/

# Установка зависимостей (включая php-amqplib)
RUN composer require php-amqplib/php-amqplib:^3.2 \
    && composer install --no-interaction

# Копирование остального проекта
COPY ./www /var/www/html

# Права доступа
RUN chown -R www-data:www-data /var/www/html

CMD ["php-fpm"]