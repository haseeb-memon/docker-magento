#!/usr/bin/env bash
########################################################################################################################
# Composer Magento Auth Setup
########################################################################################################################
echo "Setup Magento Auth For Composer";
composer global config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
########################################################################################################################
echo "Project";
cd $PROJECT_ROOT
########################################################################################################################
if [ -f ./app/etc/config.php ] || [ -f ./app/etc/env.php ]; then
  echo "It appears Magento is already installed (app/etc/config.php or app/etc/env.php exist). Exiting setup..."
  exit
fi
########################################################################################################################
echo "Delete default index files";
rm -rf * && rm -rf .DS_Store
########################################################################################################################
echo "Download Magento...";
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $PROJECT_ROOT ;
########################################################################################################################