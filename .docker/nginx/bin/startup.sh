#!/usr/bin/env sh
########################################################################################################################
echo $NGINX_PROXY;
echo $PROJECT_DOMAIN;
echo $PROJECT_URL;
########################################################################################################################
if [ "$NGINX_PROXY" = "varnish" ]
then
    echo "Proxy Varnish running";
    cp "/etc/nginx/available.d/magento-2-varnish.conf" "/etc/nginx/conf.d/default.conf";
elif [ "$NGINX_PROXY" = "php-fpm" ]
then
    echo "Proxy PHP-FPM running";
        cp "/etc/nginx/available.d/magento-2-php-fpm.conf" "/etc/nginx/conf.d/default.conf";
else
    echo "Default Nginx running";
    cp "/etc/nginx/available.d/default.conf" "/etc/nginx/conf.d/default.conf";
fi
########################################################################################################################

########################################################################################################################
[ ! -z "${NGINX_PORT}" ]        && sed -i "s/NGINX_PORT/${NGINX_PORT}/"         /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_URL}" ]       && sed -i "s/PROJECT_URL/${PROJECT_URL}/"       /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_DOMAIN}" ]    && sed -i "s/PROJECT_DOMAIN/${PROJECT_DOMAIN}/" /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_ROOT}" ]      && sed -i "s~PROJECT_ROOT~${PROJECT_ROOT}~"     /etc/nginx/conf.d/default.conf
########################################################################################################################
chown -R nginx:nginx /etc/nginx/ /etc/nginx/ssl/ /var/cache/nginx/ /var/log/nginx/ /var/www/html
nginx -t;
nginx -g 'daemon off;'
########################################################################################################################

