#!/bin/bash

set -ex

lucky set-status maintenance "Installing katharostech.com"

# Exit early if the "docker-image" resource is no present
if ! lucky get-resource docker-image; then
    lucky set-status blocked "Need \"docker-image\" resource to be uploaded."
    exit 0
fi

# Get the Docker image resource ( which is a .tgz file )
docker_image_tar=$(lucky get-resource docker-image)

# Load the docker image
cat $docker_image_tar | docker load

# Set installed flag
lucky kv set installed true

lucky set-status active