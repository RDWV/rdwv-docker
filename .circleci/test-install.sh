#!/bin/bash

set -e

# TODO: test that docker itself is installed without issues automatically (circleci issue with docker preinstalled)

cd ../..

[ -d rdwv-docker ] || mv repo rdwv-docker

cd rdwv-docker

export RDWV_HOST=rdwv.local
export REVERSEPROXY_DEFAULT_HOST=rdwv.local
export RDWV_CRYPTOS=btc,ltc
export RDWV_REVERSEPROXY=nginx
export BTC_LIGHTNING=true
# Use current repo's generator
export RDWVGEN_DOCKER_IMAGE=rdwv/docker-compose-generator:local
./setup.sh

timeout 1m bash .circleci/test-connectivity.sh

# Testing scripts are not crashing and installed
./start.sh
./stop.sh
