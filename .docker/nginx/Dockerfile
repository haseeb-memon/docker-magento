########################################################################################################################
ARG     ALPINE_VERSION="${ALPINE_VERSION:-latest}"
FROM    alpine:${ALPINE_VERSION}
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "nginx container for magento"
########################################################################################################################
# Arguments and Enviroment variables
ARG     PROJECT_DOMAIN="${PROJECT_DOMAIN:-localhost}"
ENV     PROJECT_DOMAIN=${PROJECT_DOMAIN}
########################################################################################################################
#Install System packages
RUN apk --update --no-cache add \
	shadow \
	openssl \
	nginx
########################################################################################################################
#Create system user
RUN usermod  -u 1000 nginx && \
	groupmod -g 1000 nginx
########################################################################################################################
#Copy generate self signed certificate for ssl
RUN mkdir -p /etc/nginx/ssl/ && \
	openssl req \
    -x509 \
    -nodes \
    -days   365 \
    -newkey rsa:2048 \
    -out    /etc/nginx/ssl/nginx.crt \
    -keyout /etc/nginx/ssl/nginx.key \
    -subj "/C=US/ST=New York/L=Queens/O=Docker Magento/OU=Org/CN=${PROJECT_DOMAIN}" \
 && openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
########################################################################################################################
#Copy custom configs to container
COPY .docker/nginx/config/nginx.conf        /etc/nginx/nginx.conf
COPY .docker/nginx/config/conf.d/*.conf     /etc/nginx/available.d/
########################################################################################################################
########################################################################################################################
#Copy shell executable script to container
COPY .docker/nginx/bin/startup.sh /usr/local/bin/startup.sh
RUN ["chmod", "+x", "/usr/local/bin/startup.sh"]
########################################################################################################################
WORKDIR /var/www/html
########################################################################################################################
# Run script on conatiner loading
ENTRYPOINT ["/usr/local/bin/startup.sh"]
########################################################################################################################
CMD ["nginx","-g","daemon off;"]
########################################################################################################################