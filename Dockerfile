FROM php:8.2-fpm

RUN apt-get update && apt-get install -y git unzip curl librdkafka-dev

WORKDIR /var/www/html

# Установка Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

COPY composer.json /var/www/html/
RUN composer install --ignore-platform-req=ext-sockets

COPY ./www /var/www/html

CMD ["php-fpm"]
