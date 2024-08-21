#!/usr/bin/env bash

docker image prune -af --filter "label=org.rdwv.image" --filter "label!=org.rdwv.image=docker-compose-generator"
