CURRENT_DIRECTORY := $(shell pwd)

start:
    @docker-compose up -d

clean:
    @docker-compose rm --force

stop:
    @docker-compose stop

status:
    @docker-compose ps

cli:
    @docker-compose run --rm web bash

log:
    @tail -f logs/nginx-error.log

cc:
    @docker-compose run --rm web drush cc all

restart:
    @docker-compose stop
    @docker-compose start
    @tail -f logs/nginx-error.log

.PHONY: clean start stop status cli log cc restart
