#!/bin/bash

set -ex

if [ "$(lucky kv get installed)" != "true" ]; then
    exit 0
fi

lucky set-status maintenance "Configuring application"

docker_image=$(lucky get-config docker-image)
private_address=$(lucky private-address)

# Get port from
external_port=$(lucky get-config port)

# Randomize port if requested
if [ "$external_port" = "RANDOM" ]; then
    external_port=$(lucky random -r 1024 65535)
fi

# Set the port in the kv store so that we can get to it from the update-http-relation script
lucky kv set external_port "$external_port"

lucky container image set --no-pull $docker_image
lucky container port remove --all
lucky container port add "$external_port:80"

lucky set-status active
