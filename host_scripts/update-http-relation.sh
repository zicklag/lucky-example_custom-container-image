#!/bin/bash

set -ex

lucky set-status maintenance "Updating website endpoint"

# Get endpoint config
private_address=$(lucky private-address)
external_port=$(lucky kv get external_port)

# Update all website relation data
for relation_id in $(lucky relation list-ids --relation-name website); do
    # Set the hostname and port
    lucky relation set -r $relation_id "hostname=$private_address" "port=$external_port"
done

lucky set-status active