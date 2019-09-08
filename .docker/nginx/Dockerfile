########################################################################################################################
FROM    nginx:latest
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "nginx container for magento"
########################################################################################################################
ARG NGINX_PORT=${NGINX_PORT:-80}
ARG NGINX_PROXY=${NGINX_PROXY:-default}
ARG PROJECT_URL=${PROJECT_URL}
ARG PROJECT_DOMAIN=${PROJECT_DOMAIN:-localhost}
ARG PROJECT_ROOT=${PROJECT_ROOT:-/var/www/html}
ARG TIME_ZONE=${TIME_ZONE:-Asia/Dubai}
########################################################################################################################
ENV NGINX_PORT=${NGINX_PORT}
ENV NGINX_PROXY=${NGINX_PROXY}
ENV PROJECT_URL=${PROJECT_URL}
ENV PROJECT_DOMAIN=${PROJECT_DOMAIN}
ENV PROJECT_ROOT=${PROJECT_ROOT}
ENV TIME_ZONE=${TIME_ZONE}
########################################################################################################################
#Install System packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    openssl \
    curl
########################################################################################################################
#Create system user
RUN usermod  -u 1000 nginx && \
	groupmod -g 1000 nginx
########################################################################################################################
#Create folder and generate self signed certificate for ssl
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
# TimeZone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
RUN apt-get install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata
########################################################################################################################
#Copy custom configs to container
COPY .docker/nginx/config/nginx.conf        /etc/nginx/nginx.conf
COPY .docker/nginx/config/conf.d/*.conf     /etc/nginx/available.d/
########################################################################################################################
#Copy shell executable script to container
COPY .docker/nginx/bin/startup.sh /usr/local/bin/startup.sh
RUN ["chmod", "+x", "/usr/local/bin/startup.sh"]
########################################################################################################################
# Expose Ports
EXPOSE ${NGINX_PORT} 443
########################################################################################################################
VOLUME  /var/www/html
WORKDIR /var/www/html
########################################################################################################################
# Run script on conatiner loading
ENTRYPOINT ["/usr/local/bin/startup.sh"]

