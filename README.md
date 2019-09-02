# docker-magento
Docker development environment for Magento 1 &amp; Magento 2
All images are built on Official Alpine image

## Supported tags and respective `Dockerfile` links
- `redis`       [redis/Dockerfile](.docker/redis/Dockerfile)
- `varnish`     [varnish/Dockerfile](.docker/varnish/Dockerfile)
- `nginx`       [nginx/Dockerfile](.docker/nginx/Dockerfile)
- `mysql`       [mysql/Dockerfile](.docker/mysql/Dockerfile)
- `php-fpm`     [php-fpm/Dockerfile](.docker/php-fpm/Dockerfile)
- `php-cli`     [php-cli/Dockerfile](.docker/php-cli/Dockerfile)
- `php-cron`    [php-cron/Dockerfile](.docker/php-cron/Dockerfile)

## Spinning up Docker Environment:
```shell
docker-compose up -d
```

## Shutting down Docker Environment:
```shell
docker-compose down
```

## Argument Variables

### nginx
When NGINX starts, it copies the appropriate configuration file so it can be used. This configuration file is determined by the environment variable below. If no variable is passed then the below value is set.
- NGINX_PORT=80
- NGINX_PROXY=php-fpm
- PROJECT_URL=www.your-project.com
- PROJECT_DOMAIN=your-project.com
- PROJECT_ROOT=/var/www/html
