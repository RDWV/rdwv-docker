#!/usr/bin/env bash

function convert_name() {
    docker exec -i $(container_name worker-1) python3 <<EOF
s = "$1"
s = s.replace("-log", "")
parts = s.split(".")
print(f"{parts[0]}{parts[2].replace('-','')}.log")
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. "${SCRIPT_DIR}/../../helpers.sh"
load_env
COMPOSE_DIR="$(realpath "${SCRIPT_DIR}/../../compose")"

volumes_dir=/var/lib/docker/volumes
datadir="$volumes_dir/$(volume_name rdwv_datadir)/_data"
logdir="$volumes_dir/$(volume_name rdwv_logs)/_data"
cp -rv --preserve $logdir/* $datadir/logs/
for fname in $datadir/logs/rdwv-log.log*; do
    fname_new=$(convert_name "$fname")
    mv -v "$fname" "$fname_new"
done
docker volume rm $(volume_name rdwv_logs)
cp -rv --preserve $COMPOSE_DIR/images/* $datadir/images/
rm -rf "$COMPOSE_DIR/images"
rm -rf "$COMPOSE_DIR/conf"
