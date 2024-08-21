#!/usr/bin/env bash
set -e

: "${RDWVGEN_DOCKER_IMAGE:=rdwv/docker-compose-generator}"
if [ "$RDWVGEN_DOCKER_IMAGE" == "rdwv/docker-compose-generator:local" ]; then
    docker build generator --tag $RDWVGEN_DOCKER_IMAGE
else
    set +e
    docker pull $RDWVGEN_DOCKER_IMAGE
    docker rmi $(docker images rdwv/docker-compose-generator --format "{{.Tag}};{{.ID}}" | grep "^<none>" | cut -f2 -d ';') >/dev/null 2>&1
    set -e
fi

docker run -v "$PWD/compose:/app/compose" \
    --env-file <(env | grep RDWV_) \
    --env NAME=$NAME \
    --env REVERSEPROXY_HTTP_PORT=$REVERSEPROXY_HTTP_PORT \
    --env REVERSEPROXY_HTTPS_PORT=$REVERSEPROXY_HTTPS_PORT \
    --rm $RDWVGEN_DOCKER_IMAGE $@
