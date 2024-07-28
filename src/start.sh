#!/bin/bash -e

echo 'Starting Aphrodite Engine API server...'

CMD="python3 -m aphrodite.endpoints.openai.api_server
             --host 0.0.0.0
             --port 4444
             --model /workspace/models/blackroot-8B-V1_q8_0.gguf
             --quantization gguf
             --tokenizer bluuwhale/L3-SthenoMaidBlackroot-8B-V1
             --served-model-name blackroot-8B-V1"

# set umask to ensure group read / write at runtime
umask 002

set -x

exec $CMD

python -u /handler.py --rp_serve_api --rp_api_host='0.0.0.0' --rp_api_port 8000
