#!/bin/bash -e

echo 'Starting Aphrodite Engine API server...'

# Set umask to ensure group read/write at runtime
umask 002

# Enable command tracing
set -x

# Check if a parameter is passed to determine if it should run locally
if [ "$1" = "local" ]; then
    API_HOST="0.0.0.0"
    HANDLER_CMD="python -u /handler.py --rp_serve_api --rp_api_host='0.0.0.0' --rp_api_port 8000"
else
    API_HOST="127.0.0.1"
    HANDLER_CMD="python -u /handler.py"
fi

# Start the Aphrodite Engine API server in the background
python3 -m aphrodite.endpoints.openai.api_server \
    --host $API_HOST \
    --port 4444 \
    --model /workspace/models/blackroot-8B-V1_q8_0.gguf \
    --quantization gguf \
    --tokenizer bluuwhale/L3-SthenoMaidBlackroot-8B-V1 \
    --served-model-name blackroot-8B-V1 &

# Wait for the server to start
sleep 1

# Start the RunPod handler
exec $HANDLER_CMD
