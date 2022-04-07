#!/usr/bin/env sh

set -ex

# Create a new "builder" user with the same UID as the mounted /workspace
# volume, so the host user can write the files that are spit out there
adduser -u "$(stat -c '%u' /workspace)" builder -D

# Run the passed commands as the "builder" user
su builder -c "$@"
