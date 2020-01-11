ARG PHP_VERSION=7.2
ARG COMPOSER_VERSION=1.8

FROM composer:${COMPOSER_VERSION}
FROM php:${PHP_VERSION}-cli

RUN apt-get update && \
    apt-get install -y autoconf pkg-config libssl-dev git libzip-dev zlib1g-dev && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    pecl install xdebug && docker-php-ext-enable xdebug && \
    docker-php-ext-install -j$(nproc) pdo_mysql zip

RUN sudo /bin/su -c "echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf"
RUN sudo /bin/su -c "echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf"
RUN sudo /bin/su -c "echo 'net.ipv6.conf.eth0.disable_ipv6 = 1' >> /etc/sysctl.conf"
RUN sudo /bin/su -c "sysctl -p"
RUN sudo /bin/su -c "/etc/init.d/network restart"

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR /code
