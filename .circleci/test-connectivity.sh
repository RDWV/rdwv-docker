#!/bin/bash

echo "Trying to connect to rdwv..."
while true; do
    if [ "$(curl -sL -w "%{http_code}\\n" "http://localhost/api" -o /dev/null)" == "200" ]; then
        echo "Successfully contacted RDWV"
        break
    fi
    sleep 1
done
