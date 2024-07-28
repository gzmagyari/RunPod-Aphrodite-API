#!/bin/bash -e

echo 'Starting Aphrodite Engine API server...'

CMD="python3 -m aphrodite.endpoints.openai.api_server
             --host 0.0.0.0
             --port 7860"

# set umask to ensure group read / write at runtime
umask 002

set -x

exec $CMD