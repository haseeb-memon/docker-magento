########################################################################################################################
ARG     PHP_VERSION="${PHP_VERSION:-7.3}"
FROM    php:${PHP_VERSION}-cli-alpine
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "php-cron container for magento"
########################################################################################################################
RUN apk --update --no-cache add \
	curl \
	freetype-dev \
	g++ \
	icu \
	icu-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libxml2-dev \
	libxslt-dev \
	shadow
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
	xsl
########################################################################################################################
RUN addgroup -g 1000 magento && \
	adduser -D -S -H -G magento -u 1000 -s /bin/sh magento && \
	usermod -G root -a magento
########################################################################################################################
RUN mkdir -p /etc/periodic/magento && \
	mkdir -p /var/www/html/var/log && \
	touch  /var/www/html/var/log/magento.cron.log && \
	touch  /var/www/html/var/log/update.cron.log && \
	touch  /var/www/html/var/log/setup.cron.log && \
	chown -R magento:magento /var/www/html/var/log
########################################################################################################################
COPY .docker/php-cron/bin/startup.sh /usr/local/bin/startup.sh
COPY .docker/php-cron/config/crontab /etc/periodic/magento/cron
COPY .docker/php-cron/config/php.ini /usr/local/etc/php/php.ini
########################################################################################################################
RUN crontab -u magento /etc/periodic/magento/cron
########################################################################################################################
WORKDIR /var/www/html
CMD [ "sh", "/usr/local/bin/startup.sh" ]
