#!/usr/bin/env bash

set -e

. helpers.sh
load_env

cd "$RDWV_BASE_DIRECTORY"

# Create a backup
./backup.sh
# First, update to latest stable release, then we can apply staging changes
./update.sh

COMPONENTS=$(./build.sh --components-only | tail -1)
IFS=', ' read -r -a CRYPTOS <<<"$RDWV_CRYPTOS"

./dev-setup.sh

cd compose

if [[ " ${COMPONENTS[*]} " =~ " backend " ]]; then
    docker build -t rdwv/rdwv:stable -f backend.Dockerfile . || true
fi

for coin in "${CRYPTOS[@]}"; do
    docker build -t rdwv/rdwv-$coin:stable -f $coin.Dockerfile . || true
done

cd ..
rm -rf compose/rdwv

build_additional_image() {
    if [[ " ${COMPONENTS[*]} " =~ " $1 " ]]; then
        OLDDIR="$PWD"
        TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
        cd $TEMP_DIR
        git clone https://github.com/rdwv/rdwv-$1
        cd rdwv-$1
        docker build -t rdwv/rdwv-$1:stable . || true
        cd "$OLDDIR"
        rm -rf $TEMP_DIR
    fi
}

build_additional_image admin
build_additional_image store
rdwv_reset_plugins
rdwv_start
