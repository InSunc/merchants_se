#!/bin/bash

set -e

rm -f /railsapp/tmp/pids/server.pid

# exec the container's main process (CMD of the Dockerfile)
exec "$@"
