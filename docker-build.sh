#!/usr/bin/env bash

set -ex

# Make sure we have the docker utility
if ! command -v docker; then
    echo "🐋 Please install docker first 🐋"
    exit 1
fi

# Set the docker image name to default to repo basename
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-$(basename -s .git "$(git remote --verbose | awk 'NR==1 { print tolower($2) }')")}

# build the docker image
DOCKER_BUILDKIT=1 docker build -t "$DOCKER_IMAGE_NAME" -f Dockerfile .

# build the project in the docker container
# include the -i and prompt if running in interactive mode
if [ -t 0 ] && [ -t 1  ]; then
    TTY_ARG="-i"
fi
docker run --rm ${TTY_ARG} -v "$(pwd)":/workspace -t rp2040-cdc-console \
        "cmake -B build -GNinja && cmake --build build"
