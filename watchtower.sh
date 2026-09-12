#!/bin/bash

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once --cleanup

docker image prune -f

# this file setup:
# nano watchtower.sh
# chmod +x watchtower.sh
# run:
# ./watchtower.sh