# docker-magento
Docker development environment for Magento 1 &amp; Magento 2

### Infrastructure overview
* Container 1:  Nginx + Self Signed SSL Terminator + HTTP 2
* Container 2:  PHP-FPM
* Container 3:  PHP-CLI
* Container 4:  PHP-CRON
* Container 5:  MariaDB
* Container 6:  PhpMyAdmin
* Container 7:  Redis (for Magento's cache)
* Container 8:  Redis (for Magento's full page cache)
* Container 9:  Redis (for Magento's sessions cache)
* Container 10: Varnish
* Container 11: ElasticSearch
* Container 12: LogStash
* Container 13: Kibana
* Container 14: RabbitMQ (Queuing System)
* Container 15: MailHog  (Email System)


### Why a separate cron container?

All containers should be single process as possible, with this separation, we can easily scale our system with docker swarm and kubernetes. 
you may also be able to separate resources allocated to the cron container from the rest of the infrastructure.


### Prerequisites

This setup assumes you are running Docker on a computer with at least 6GB of allocated RAM, a quad-core, and an SSD hard drive.
Make sure that port 80/443 and 3306 are not being used by other services. 
if docker is not installed on your system. do the following.

**MacOS:**

Install 
    [Docker](https://docs.docker.com/docker-for-mac/install/)
    [Docker-compose](https://docs.docker.com/compose/install/#install-compose)
    [Make](https://www.gnu.org/software/make/)

**Windows:**

Install 
    [Docker](https://docs.docker.com/docker-for-windows/install/)
    [Docker-compose](https://docs.docker.com/compose/install/#install-compose)
    [Make](https://www.gnu.org/software/make/)

**Linux:**

Install 
    [Docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
    [Docker-compose](https://docs.docker.com/compose/install/#install-compose)
    [Make](https://www.gnu.org/software/make/)


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


## Manage dockers with container with make

List commands, bring containers  up, down, list, build...

    make docker:ps
    make docker:build
    make docker:up
    make docker:down



### Composer Authentication

Get your authentication keys for Magento Marketplace. 
For more information about Magento Marketplace authentication, see the [DevDocs](http://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html).  
The setup script will require you to provide authentication information!

To configure authentication, update .env file with your Magento public and private keys, respectively.


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

## Varnish

Varnish is running out of the container by default. If you do not require varnish, then you will need to remove the varnish block from your `docker-compose.yml` and update the `nginx proxy` variable to `php-fpm` container definition.

To clear varnish, you can use the `make varnish:flush` to clear the cache. 
Alternatively, you could restart the varnish container. `make docker:restart <varnish container name>`
If you need to add your own VCL, then it needs to be mounted to: `/data/varnish.vcl`.



### Elastic stack (ELK)

Run Magento 2 with the latest version of the ELK (Elasticsearch, Logstash, Kibana) stack with Docker and Docker Compose.

It will give you the ability to analyze magento catalog data set by using the searching/aggregation capabilities of Elasticsearch
and the visualization power of Kibana.

Based on the official Docker images from Elastic:

* [Elasticsearch]
* [Logstash]
* [Kibana]


### Access services (elasticsearch and kibana)
Give few seconds to initialize elasticsearch and kibana, then 

open web browser to server (elasticsearch):

    open http://localhost:9200
    
open web browser to client (kibana):    
    
    open http://localhost:5601


### Datasource Adminer

- PHPMyAdmin: http://localhost:8888