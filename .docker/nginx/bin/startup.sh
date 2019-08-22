#!/usr/bin/env sh
########################################################################################################################
if [[ "$VERBOSE" == "true" ]]; then
	mkdir -p    /var/log/nginx
	touch       /var/log/nginx/error.log /var/log/nginx/access.log
	tail -f     /var/log/nginx/*.log &
fi
########################################################################################################################
if [[ "${NGINX_FORCE_SSL}" == "true" ]]; then
    echo "Forcing Secure Website";
    cp "/etc/nginx/available.d/default-ssl.conf" "/etc/nginx/conf.d/default.conf"
else
    echo "Nomal & Secure Website";
    cp "/etc/nginx/available.d/default.conf" "/etc/nginx/conf.d/default.conf"
fi
########################################################################################################################
[ ! -z "${NGINX_UNSECURE_PORT}" ]   && sed -i "s~NGINX_UNSECURE_PORT~${NGINX_UNSECURE_PORT}~"   /etc/nginx/conf.d/default.conf
[ ! -z "${NGINX_SECURE_PORT}" ]     && sed -i "s~NGINX_SECURE_PORT~${NGINX_SECURE_PORT}~"       /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_URL}" ]           && sed -i "s~PROJECT_URL~${PROJECT_URL}~"                   /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_DOMAIN}" ]        && sed -i "s~PROJECT_DOMAIN~${PROJECT_DOMAIN}~"             /etc/nginx/conf.d/default.conf
[ ! -z "${PROJECT_ROOT}" ]          && sed -i "s~PROJECT_ROOT~${PROJECT_ROOT}~"                 /etc/nginx/conf.d/default.conf
########################################################################################################################
chown -R nginx:nginx /var/www /var/tmp/nginx
nginx -g 'daemon off;'
nginx -t;