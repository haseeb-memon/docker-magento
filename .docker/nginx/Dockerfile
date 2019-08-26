########################################################################################################################
FROM    nginx:alpine
########################################################################################################################
LABEL   Maintainer  =   "Haseeb Memon <memon.haseeb@hotmail.com>"
LABEL   Description =   "nginx container for magento"
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
#Create folder and generate self signed certificate for ssl
RUN mkdir -p /etc/nginx/ssl/ && \
	openssl req \
    -x509 \
    -nodes \
    -days   365 \
    -newkey rsa:2048 \
    -out    /etc/nginx/ssl/nginx.crt \
    -keyout /etc/nginx/ssl/nginx.key \
    -subj "/C=US/ST=New York/L=Queens/O=Docker Magento/OU=Org/CN=magento.local" \
 && openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
########################################################################################################################
#Copy custom configs to container
COPY .docker/nginx/config/nginx.conf        /etc/nginx/nginx.conf
COPY .docker/nginx/config/conf.d/*.conf     /etc/nginx/conf.d/
########################################################################################################################
#Copy shell executable script to container
COPY .docker/nginx/bin/startup.sh /usr/local/bin/startup.sh
RUN ["chmod", "+x", "/usr/local/bin/startup.sh"]
########################################################################################################################
# Expose Ports
EXPOSE 80 443
########################################################################################################################
WORKDIR /var/www/html
########################################################################################################################
# Run script on conatiner loading
ENTRYPOINT ["/usr/local/bin/startup.sh"]

