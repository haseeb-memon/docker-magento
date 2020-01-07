#!/bin/bash
########################################################################################################################
# Composer Magento Auth Setup
########################################################################################################################
echo "Setup Magento Auth For Composer";
composer global config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
########################################################################################################################
cd $PROJECT_ROOT
########################################################################################################################
if [ -f ./app/etc/config.php ] || [ -f ./app/etc/env.php ]; then
  echo "It appears Magento is already installed (app/etc/config.php or app/etc/env.php exist). Exiting setup..."
  exit
fi
########################################################################################################################
echo "Delete default index files";
rm -rf * && rm -rf .*
########################################################################################################################
echo "Download Magento...";
if [[ -z $MAGENTO_VERSION ]]; then
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $PROJECT_ROOT ;
else
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION $PROJECT_ROOT ;
fi
########################################################################################################################
echo "Fixing File Permissions...";
chmod u+w -R ./var ./vendor ./pub/static ./pub/media ./app/etc ./generated  ./var/page_cache/
#chown -R www-data:www-data $PROJECT_ROOT
chmod u+x ./bin/magento
########################################################################################################################
echo "Installing Magento"
php bin/magento setup:install \
--admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
--admin-lastname=$MAGENTO_ADMIN_LASTNAME \
--admin-email=$MAGENTO_ADMIN_EMAIL \
--admin-user=$MAGENTO_ADMIN_USERNAME \
--admin-password=$MAGENTO_ADMIN_PASSWORD \
--base-url=$MAGENTO_BASE_URL \
--base-url-secure=$MAGENTO_SECURE_BASE_URL \
--backend-frontname=$MAGENTO_BACKEND_FRONTNAME \
--db-host=$MAGENTO_DB_HOST \
--db-name=$MAGENTO_DB_NAME \
--db-user=$MAGENTO_DB_USER \
--db-password=$MAGENTO_DB_PASSWORD \
--use-rewrites=1 \
--language=$MAGENTO_LANGUAGE \
--currency=$MAGENTO_DEFAULT_CURRENCY \
--timezone=$MAGENTO_TIMEZONE \
--use-secure-admin=1 \
--admin-use-security-key=1 \
--session-save=files \
--use-sample-data;
########################################################################################################################
if [ "$MAGENTO_USE_SAMPLE_DATA" == "true" ]; then
    echo "Install Sample Data";
    cp /var/www/.composer/auth.json /var/www/html/var/composer_home/auth.json;
    php -f ./bin/magento sampledata:deploy;
    php -f ./bin/magento setup:upgrade;
fi
########################################################################################################################
echo "Configure Redis"
php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis-cache     --cache-backend-redis-port=6379 --cache-backend-redis-db=0;
php bin/magento setup:config:set --page-cache=redis    --page-cache-redis-server=redis-page-cache   --page-cache-redis-port=6379    --page-cache-redis-db=0;
echo "Y" | php bin/magento setup:config:set --session-save=redis  --session-save-redis-host=redis-session      --session-save-redis-port=6379 --session-save-redis-log-level=3 --session-save-redis-db=0;
########################################################################################################################
echo "Configure RabbitMQ"
php bin/magento setup:config:set --amqp-host="$MAGENTO_AMQP_HOST" --amqp-port="$MAGENTO_AMQP_PORT" --amqp-user="$MAGENTO_AMQP_USER" --amqp-password="$MAGENTO_AMQP_PASSWORD" --amqp-virtualhost="/"
########################################################################################################################
echo "Configure ElasticSearch"
#composer require smile/elasticsuite ^2.8.0
#php bin/magento cache:clean
#php bin/magento cache:flush
#php bin/magento module:enable Smile_ElasticsuiteCore Smile_ElasticsuiteCatalog Smile_ElasticsuiteSwatches Smile_ElasticsuiteCatalogRule Smile_ElasticsuiteVirtualCategory Smile_ElasticsuiteThesaurus Smile_ElasticsuiteCatalogOptimizer Smile_ElasticsuiteTracker
#php bin/magento setup:upgrade
#php bin/magento setup:di:compile
#php bin/magento indexer:reindex
#php bin/magento index:reindex catalogsearch_fulltext
#php bin/magento index:reindex elasticsuite_categories_fulltext
#php bin/magento index:reindex elasticsuite_thesaurus
########################################################################################################################
php bin/magento config:set catalog/search/engine elasticsearch6
php bin/magento config:set catalog/search/elasticsearch6_server_hostname elasticsearch
php bin/magento cache:flush;
php bin/magento indexer:reindex catalogsearch_fulltext
#php bin/magento indexer:reindex
########################################################################################################################
echo "Configure Magento"
php bin/magento maintenance:enable;
php bin/magento setup:upgrade;
php bin/magento setup:di:compile;
php bin/magento setup:static-content:deploy -f;
php bin/magento indexer:reindex;
php bin/magento indexer:set-mode schedule;
php bin/magento cache:flush;
php bin/magento maintenance:disable;
########################################################################################################################
echo "Optimize Magento"
#rm -rf var/cache var/page_cache var/generation var/di generated/*
#rm -rf generated/metadata/* generated/code/*
#php bin/magento deploy:mode:set production
php bin/magento config:set catalog/frontend/flat_catalog_category 1
php bin/magento config:set catalog/frontend/flat_catalog_product 1
php bin/magento config:set sitemap/generate/enabled 1
php bin/magento indexer:reindex
########################################################################################################################
echo "Disable Temando_Shipping"
php bin/magento module:disable Temando_Shipping
rm -rf var/cache/ generated/ pub/static/
php bin/magento setup:upgrade
php bin/magento setup:static-content:deploy -f
php bin/magento setup:di:compile
chmod -R 777 var/ pub/ generated/