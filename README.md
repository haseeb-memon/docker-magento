# docker-magento
Docker development environment for Magento 1 &amp; Magento 2

### Infrastructure overview
* Container 1: Nginx + Self Signed SSL Terminator + HTTP 2
* Container 2: PHP-FPM
* Container 3: PHP-CLI
* Container 4: PHP-CRON
* Container 5: MariaDB
* Container 6: Redis (for Magento's cache)
* Container 7: Redis (for Magento's full page cache)
* Container 8: Redis (for Magento's sessions cache)
* Container 9: Varnish

### Why a separate cron container?

All containers should be single process as possible, with this separation, we can easily scale our system with docker swarm and kubernetes. 
you may also be able to separate resources allocated to the cron container from the rest of the infrastructure.


### Prerequisites

This setup assumes you are running Docker on a computer with at least 6GB of allocated RAM, a quad-core, and an SSD hard drive.
Make sure that port 80/443 and 3306 are not being used by other services. 
if docker is not installed on your system. do the following.

**MacOS:**

Install [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose).

**Windows:**

Install [Docker](https://docs.docker.com/docker-for-windows/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) .

**Linux:**

Install [Docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) and [Docker-compose](https://docs.docker.com/compose/install/#install-compose).


# Usage
1. clone repository
2. run `mv .env.dist .env`
3. update `<project_root_folder_>/.env` with your project's environment variables
4. echo "127.0.0.1 magento.local" | sudo tee -a /etc/hosts
4. run `docker-compose up -d`
5. bin/setup magento2.local
6. open https://magento.local 


#### New Projects

```bash
# Download the Docker Compose template:
clone repository

# Move enviroment variable file:
mv .env.dist .env

# Update enviroment variable file with your project's environment variables:
<project_root_folder_>/.env

# Create a DNS host entry for the site:
echo "127.0.0.1 www.magento.local" | sudo tee -a /etc/hosts

# Run the container and setup Magento:
make magento:setup

open https://www.magento.local
```


### Composer Authentication

Get your authentication keys for Magento Marketplace. 
For more information about Magento Marketplace authentication, see the [DevDocs](http://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html).  
The setup script will require you to provide authentication information!

To manually configure authentication, copy `src/auth.json.sample` to `src/auth.json`. Then, update the username and password values with your Magento public and private keys, respectively. Finally, copy the file to the container by running `bin/copytocontainer auth.json`.



### Redis

Redis is now the default cache and session storage engine, and is automatically configured & enabled when running `startup.sh` on new installs.

Use the following lines to enable Redis on existing installs:

**Enable for Cache:**

`bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis-cache --cache-backend-redis-db=0`

**Enable for Full Page Cache:**

`bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis-page-cache --page-cache-redis-db=0`

**Enable for Session:**

`bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=4 --session-save-redis-db=0`

You may also monitor Redis by running: `bin/redis redis-cli monitor`

For more information about Redis usage with Magento, see the <a href="https://devdocs.magento.com/guides/v2.3/config-guide/redis/redis-session.html" target="_blank">DevDocs</a>.


