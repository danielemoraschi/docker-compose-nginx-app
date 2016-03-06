CURRENT_DIRECTORY := $(shell pwd)

start:
    @docker-compose up --no-deps -d

clean:
    @docker-compose rm --force

stop:
    @docker-compose stop

ps:
    @docker-compose ps

cli:
    @docker exec -ti $1 bash

log:
    @docker-compose logs

cc:
    @docker-compose run --rm $1 $2

restart:
    @docker-compose restart

.PHONY: clean start stop status cli log cc restart
