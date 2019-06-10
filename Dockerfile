ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

WORKDIR /build
USER root

ENV APK_PACKAGES \
        nodejs-current-npm \
        php7 \
        php7-openssl \
        php7-json \
        php7-phar \
        php7-gd \
        php7-intl \
        php7-zlib \
        php7-curl \
        php7-mbstring \
        php7-iconv \
        php7-pear \
        php7-tokenizer \
        php7-dev \
        php7-pdo \
        php7-pdo_mysql \
        php7-dom \
        php7-xml \
        git \
        g++ \
        musl-dev \
        make \
        icu-dev \
        libpng-dev \
        rsync \
        openssh \
        curl

ENV PECL_PACKAGES \
        xdebug \
        igbinary \
        mcrypt \
        exif
        
RUN apk update && apk upgrade

## install packages
RUN apk add --no-cache ${APK_PACKAGES}

## Gulp
RUN npm install --global gulp

## Grunt
RUN npm install -g grunt-cli

## pecl
RUN pecl install ${PECL_PACKAGES}

## Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
RUN php -r "unlink('composer-setup.php');"

## deployer.phar
COPY deployer.phar /usr/local/bin
RUN chmod +x /usr/local/bin/deployer.phar

ENTRYPOINT [ "/bin/sh" ]
