#FROM php:5.6-apache
FROM php:7.2.0-apache
EXPOSE 80

RUN a2enmod rewrite expires

# install the PHP extensions we need
#RUN apt-get update && apt-get install -y --force-yes libpng12-dev libjpeg-dev libkrb5-dev
#    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
#    && docker-php-ext-install gd mysqli \
#    && apt-get -y install libssl-dev libc-client2007e-dev libkrb5-dev \
#    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
#    && docker-php-ext-install imap opcache \
#    && rm -rf /var/lib/apt/lists/*

# setting the recommended for vtiger
RUN { \
        echo 'display_errors=On'; \
        echo 'max_execution_time=0'; \
        echo 'error_reporting=E_WARNING & ~E_NOTICE & ~E_DEPRECATED'; \
        echo 'log_errors=Off'; \
        echo 'short_open_tag=On'; \
    } > /usr/local/etc/php/conf.d/vtiger-recommended.ini

# setting the reccomended for opcache
# https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

RUN curl --insecure -o vtigercrm.tar.gz -SL https://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%207.0.1/Core%20Product/vtigercrm7.0.1.tar.gz \
    && tar -xzf vtigercrm.tar.gz \
    && rm vtigercrm.tar.gz \
    && chmod -R 775 vtigercrm \
    && chown -R www-data:www-data vtigercrm

COPY entrypoint.bash /entrypoint.bash

ENTRYPOINT ["/entrypoint.bash"]

CMD ["apache2-foreground"]