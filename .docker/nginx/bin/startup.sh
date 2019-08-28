#!/usr/bin/env sh
########################################################################################################################
if [[ "${NGINX_PROXY}" == "php-fpm" ]]; then
    echo "Proxy PHP-FPM running";
    cp "/etc/nginx/available.d/magento-2-php-fpm.conf" "/etc/nginx/conf.d/default.conf"
else
    echo "Proxy Varnish running";
    cp "/etc/nginx/available.d/magento-2-varnish.conf" "/etc/nginx/conf.d/default.conf"
fi
########################################################################################################################
[ ! -z "${NGINX_PORT}" ]        && sed -i "s/NGINX_PORT/${NGINX_PORT}/"         /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_URL}" ]       && sed -i "s/PROJECT_URL/${PROJECT_URL}/"       /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_DOMAIN}" ]    && sed -i "s/PROJECT_DOMAIN/${PROJECT_DOMAIN}/" /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_ROOT}" ]      && sed -i "s~PROJECT_ROOT~${PROJECT_ROOT}~"     /etc/nginx/conf.d/default.conf
########################################################################################################################
nginx -t;
nginx -g 'daemon off;'
########################################################################################################################

