# Ecommerce Makefile

SHELL   := /bin/bash # Use bash syntax
VERSION := $(shell git rev-list HEAD --count --no-merges)

args    = `arg="$(filter-out $(firstword $(MAKECMDGOALS)),$(MAKECMDGOALS))" && echo $${arg:-${1}}`

green   = $(shell echo -e '\x1b[32;01m$1\x1b[0m')
yellow  = $(shell echo -e '\x1b[33;01m$1\x1b[0m')
red	    = $(shell echo -e '\x1b[33;31m$1\x1b[0m')

format  = $(shell printf "%s %-40s %s" "$(call yellow,$1)" "$(call green,$2)" $3)

.DEFAULT_GOAL:=help

.PHONY: install

.SILENT:

%:
	@:

# show some help
help:
	@echo "$(call green,'Use the following commands:')"
	@echo "$(call red,'Help')"
	@echo "$(call format,'make','help','Print list of commands with comment')"

	@echo "$(call red,'Docker')"
	@echo "$(call format,'make','docker:up','Up all containers')"
	@echo "$(call format,'make','docker:down','Down all containers')"
	@echo "$(call format,'make','docker:ps','Show containers statuses')"
	@echo "$(call format,'make','docker:exec','Run container')"
	@echo "$(call format,'make','docker:log','Show container logs')"
	@echo "$(call format,'make','docker:start','Start container')"
	@echo "$(call format,'make','docker:stop','Stop container')"
	@echo "$(call format,'make','docker:restart','Restart container')"
	@echo "$(call format,'make','docker:build','Start build containers')"
	@echo "$(call format,'make','docker:clean','Clean docker images and volumes')"

	@echo "$(call red,'Magento')"
	@echo "$(call format,'make','magento:setup','Run all container with new magento installation')"
	@echo "$(call format,'make','magento:cli','Opens magento cli container')"

	@echo "$(call red,'Redis')"
	@echo "$(call format,'make','redis:monitor','Monitor Redis CLI Logs')"
	@echo "$(call format,'make','redis:flush','Flush Redis Cache')"

	@echo "$(call red,'Mysql')"
	@echo "$(call format,'make','mysql:backup','Backup mysql database')"
	@echo "$(call format,'make','mysql:restore','Restore mysql database in container')"



docker\:up:
	@echo "$(call yellow, 'Up all containers')"
	@docker-compose -f docker-compose.yml up -d

docker\:down:
	@echo "$(call yellow, 'Down all containers')"
	@docker-compose down $(call args)

docker\:ps:
	@echo "$(call yellow, 'Show containers statuses')"
	@docker-compose ps $(call args)

docker\:exec:
	@echo "$(call yellow, 'Run container:') $(call red,$(call args))"
	@docker exec -it $(call args)

docker\:log:
	@echo "$(call yellow, 'Show container log:') $(call red,$(call args))"
	@docker logs -f $(call args)

docker\:start:
	@echo "$(call yellow, 'Start container:') $(call red,$(call args))"
	@docker-compose start $(call args)

docker\:stop:
	@echo "$(call yellow, 'Stop container:') $(call red,$(call args))"
	@docker stop $(call args)

docker\:restart:
	@echo "$(call yellow, 'Restart container:') $(call red,$(call args))"
	@docker restart $(call args)

docker\:build:
	@echo "$(call yellow,'Start build containers')"
	@docker-compose -f docker-compose.yml build $(call args)

docker\:clean:
	@echo "$(call yellow,'Clean docker images and volumes')"
	@docker-compose down $(call args)
	docker system prune --volumes --filter "label=magento"

magento\:setup:
	@echo "$(call yellow,'Start building containers and magento installation')"
	@docker-compose -f docker-compose.yml up -d --build $(call args)
	@docker exec -it magento_php_cli bash -c 'bash /usr/local/bin/startup.sh'

magento\:cli:
	@echo "$(call yellow,'Opens magento cli container')"
	@docker exec -it magento_php_cli bash

## Monitor Redis cache
redis\:monitor:
	@echo "$(call yellow,'Monitor Redis CLI Logs')"
	@docker exec -it $(call args) sh -c 'redis-cli monitor'

## Flush Redis cache
redis\:flush:
	@echo "$(call yellow,'Monitor Redis CLI Logs')"
	@docker exec -it $(call args) sh -c 'redis-cli flushall'

## Backup the "mysql" volume
mysql\:backup:
    @docker run --rm \
        --volumes-from $$(docker-compose ps -q mysql) \
        --volume $$(pwd):/backup \
        busybox sh -c "tar cvf /backup/backup.tar /var/lib/mysql"

## Restore the "mysql" volume
mysql\:restore:
	@docker run --rm \
		--volumes-from $$(docker-compose ps -q mysql) \
		--volume $$(pwd):/backup \
		busybox sh -c "tar xvf /backup/backup.tar var/lib/mysql/"
	@docker-compose restart mysql