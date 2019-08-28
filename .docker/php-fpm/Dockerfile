########################################################################################################################
ARG     PHP_VERSION="${PHP_VERSION:-7.2}"
FROM    php:${PHP_VERSION}-fpm-alpine
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "php-fpm container for magento"
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
	zlib-dev
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
RUN docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install opcache
########################################################################################################################
RUN { \
		echo 'opcache.memory_consumption=256'; \
		echo 'opcache.interned_strings_buffer=16'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
########################################################################################################################
RUN rm -rf /var/cache/apk/* \
    && rm -rf /tmp/pear \
    && rm -rf /var/lib/apt/lists/* && rm -rf && rm -rf /var/lib/cache/* && rm -rf /var/lib/log/* \
    && rm -rf /tmp/* && rm -rf /var/tmp/*

########################################################################################################################
#Create system user
RUN usermod  -u 1000 nobody && \
	groupmod -g 1000 nobody
########################################################################################################################
########################################################################################################################
#Copy custom configs to container
COPY .docker/php-fpm/config/php.ini     /usr/local/etc/php/php.ini
COPY .docker/php-fpm/config/www.conf    /usr/local/etc/php-fpm.d/www.conf
########################################################################################################################
#Copy shell executable script to container
COPY .docker/php-fpm/bin/startup.sh     /usr/local/bin/startup.sh
RUN ["chmod", "+x", "/usr/local/bin/startup.sh"]
########################################################################################################################
# Expose Ports
EXPOSE 9000
########################################################################################################################
WORKDIR /var/www/html
########################################################################################################################
# Run script on conatiner loading
CMD [ "sh", "/usr/local/bin/startup.sh" ]
