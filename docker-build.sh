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
DOCKER_BUILDKIT=1 docker build -t "$DOCKER_IMAGE_NAME" --build-arg "UID=$(id -u)" -f Dockerfile .

# build the project in the docker container
# include the -i and prompt if running in interactive mode
if [ -t 0 ] && [ -t 1  ]; then
    TTY_ARG="-i"
    # shellcheck disable=SC2016
    TTY_EXTRA=' && read -p ">>> Run '"'"'docker cp $(cat /etc/hostname):/tmp/build/rp2040_cdc_console.uf2 ./'"'"' to save the built UF2 file, then press ENTER"'
fi
docker run --rm ${TTY_ARG} -v "$(pwd)":/workspace --workdir /workspace -t rp2040-cdc-console \
    bash -c \
        "cmake -B /tmp/build -GNinja && cmake --build /tmp/build${TTY_EXTRA}"
