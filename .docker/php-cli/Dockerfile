########################################################################################################################
ARG     PHP_VERSION="${PHP_VERSION:-7.2}"
FROM    php:${PHP_VERSION}-cli
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "php-cli container for magento"
########################################################################################################################
RUN apt-get update && apt-get install -y \
	curl \
	g++ \
	libfreetype6-dev \
	libicu-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libxml2-dev \
	libxslt-dev \
	libzip-dev  \
	zip         \
	unzip
########################################################################################################################
RUN docker-php-ext-configure \
	gd --with-jpeg-dir=/usr/local/ --with-freetype-dir=/usr/include/
########################################################################################################################
RUN docker-php-ext-install \
	gd \
	bcmath \
	intl \
	pdo_mysql \
	soap \
	xsl \
	zip
########################################################################################################################
RUN rm -rf /var/cache/apk/* \
    && rm -rf /tmp/pear \
    && rm -rf /var/lib/apt/lists/* && rm -rf && rm -rf /var/lib/cache/* && rm -rf /var/lib/log/* \
    && rm -rf /tmp/* && rm -rf /var/tmp/*
########################################################################################################################
#Copy shell executable script to container
COPY .docker/php-cli/bin/ /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/"]
########################################################################################################################
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME=${COMPOSER_HOME}
########################################################################################################################
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
########################################################################################################################
RUN composer global require hirak/prestissimo
########################################################################################################################
########################################################################################################################
COPY .docker/php-cli/config/php.ini /usr/local/etc/php/php.ini
########################################################################################################################
WORKDIR /var/www/html
ENTRYPOINT [ "sh", "-l" ]