include .env
export

# Local config
CONTAINER_NAME=cashtrack_redis
DB_PORT=6379

# Deploy config
REPO=cashtrack/redis
IMAGE_RELEASE=$(REPO):$(RELEASE_VERSION)
IMAGE_DEV=$(REPO):dev
IMAGE_LATEST=$(REPO):latest

.PHONY: build tag push start stop network

build:
	docker build . -t $(IMAGE_DEV) --no-cache

tag:
	docker tag $(IMAGE_DEV) $(IMAGE_RELEASE)
	docker tag $(IMAGE_DEV) $(IMAGE_LATEST)

push:
	docker push $(IMAGE_RELEASE)
	docker push $(IMAGE_LATEST)

start:
	mkdir -p data
	[[ "$(shell docker container inspect -f '{{.State.Running}}' $(CONTAINER_NAME))" == "true" ]] || docker run \
	  --rm \
      --name $(CONTAINER_NAME) \
      --net cash-track-local \
      -v "$(PWD)/data":/data \
      -p $(DB_PORT):6379 \
      -d \
      $(IMAGE_DEV) redis-server /usr/local/etc/redis/redis.conf --loglevel notice

stop:
	docker stop $(CONTAINER_NAME)

network:
	docker network create --driver bridge cash-track-local || true
