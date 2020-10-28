FROM ghcr.io/rez0n/php-5.3-apache

LABEL org.opencontainers.image.source https://github.com/rez0n/docker-phpmyadmin-4.0.x
ENV PMA_VERSION "4.0.10.20"
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    mysql-client \
    && rm -r /var/lib/apt/lists/*

RUN set -ex; \
    \
    { \
    echo 'session.cookie_httponly = 1'; \
    echo 'session.use_strict_mode = 1'; \
    } > $PHP_INI_DIR/conf.d/session-strict.ini; \
    \
    { \
    echo 'allow_url_fopen = Off'; \
    echo 'max_execution_time = 600'; \
    echo 'memory_limit = 512M'; \
    } > $PHP_INI_DIR/conf.d/phpmyadmin-misc.ini

RUN rm -rf /var/www/html/* \
    && curl https://files.phpmyadmin.net/phpMyAdmin/$PMA_VERSION/phpMyAdmin-$PMA_VERSION-all-languages.tar.gz | tar -xvz --strip-components=1 \
    && mkdir -p /var/www/html/tmp /etc/phpmyadmin \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/www/html/setup/ /var/www/html/examples/ /var/www/html/test/ /var/www/html/po/ /var/www/html/composer.json /var/www/html/RELEASE-DATE-$PMA_VERSION \
    && sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /var/www/html/libraries/vendor_config.php

COPY ./config.inc.php /etc/phpmyadmin/config.inc.php
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["apache2-foreground"]