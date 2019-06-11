FROM php:7.3-cli-alpine3.9

WORKDIR /build

ENV APK_PACKAGES \
        nodejs-current-npm \
        git \
        g++ \
        musl-dev \
        make \
        icu-dev \
        libpng-dev \
        rsync \
        openssh \
        openssl \
        openssl-dev \
        curl \
        curl-dev \
        libxml2 \
        libxml2-dev

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk update && apk upgrade

## install alpine packages
RUN apk add --no-cache ${APK_PACKAGES}

## install php packages
RUN docker-php-ext-install -j$(nproc) exif intl pdo_mysql \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd

## Gulp
RUN npm install --global gulp

## Grunt
RUN npm install -g grunt-cli

## Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN composer self-update

## deployer.phar
COPY deployer.phar /usr/local/bin
RUN chmod +x /usr/local/bin/deployer.phar

WORKDIR /app

ENTRYPOINT [ "/bin/sh" ]
