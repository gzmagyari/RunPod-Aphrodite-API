#!/bin/bash -e

echo 'Starting Aphrodite Engine API server...'

# Set umask to ensure group read/write at runtime
umask 002

# Enable command tracing
set -x

# Start the Aphrodite Engine API server in the background
if [ "$1" = "local" ]; then
    python3 -m aphrodite.endpoints.openai.api_server \
        --host 0.0.0.0 \
        --port 4444 \
        --model /workspace/models/blackroot-8B-V1_q8_0.gguf \
        --quantization gguf \
        --tokenizer bluuwhale/L3-SthenoMaidBlackroot-8B-V1 \
        --served-model-name blackroot-8B-V1 &
else
    python3 -m aphrodite.endpoints.openai.api_server \
        --host 127.0.0.1 \
        --port 4444 \
        --model /workspace/models/blackroot-8B-V1_q8_0.gguf \
        --quantization gguf \
        --tokenizer bluuwhale/L3-SthenoMaidBlackroot-8B-V1 \
        --served-model-name blackroot-8B-V1 &
fi

# Wait for the server to start
sleep 1

# Start the RunPod handler
if [ "$1" = "local" ]; then
    exec python -u /handler.py --rp_serve_api --rp_api_host='0.0.0.0' --rp_api_port 8000
else
    exec python -u /handler.py
fi