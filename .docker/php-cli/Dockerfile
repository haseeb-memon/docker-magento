########################################################################################################################
ARG     PHP_VERSION="${PHP_VERSION:-7.2}"
FROM    php:${PHP_VERSION}-cli-alpine
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "php-cli container for magento"
########################################################################################################################
RUN apk --update --no-cache add \
	curl \
	g++ \
	freetype-dev \
	icu \
	icu-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libxml2-dev \
	libxslt-dev \
	shadow \
	zlib-dev \
	libzip-dev
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
########################################################################################################################
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
########################################################################################################################
RUN composer global require hirak/prestissimo
########################################################################################################################
########################################################################################################################
COPY .docker/php-cli/config/php.ini /usr/local/etc/php/php.ini
COPY .docker/php-cli/config/aliases.sh /etc/profile.d/aliases.sh
########################################################################################################################
WORKDIR /var/www/html
ENTRYPOINT [ "sh", "-l" ]