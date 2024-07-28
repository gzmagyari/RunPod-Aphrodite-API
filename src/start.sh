#!/bin/bash -e

echo 'Starting Aphrodite Engine API server...'

CMD="python3 -m aphrodite.endpoints.openai.api_server
             --host 0.0.0.0
             --port 4444
             --model /workspace/models/blackroot-8B-V1_q8_0.gguf
             --q gguf
             --tokenizer bluuwhale/L3-SthenoMaidBlackroot-8B-V1
             --served-model-name blackroot-8B-V1"

# set umask to ensure group read / write at runtime
umask 002

set -x

exec $CMD