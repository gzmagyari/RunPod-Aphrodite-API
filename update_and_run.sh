#!/bin/bash
git pull
sudo docker stop $(sudo docker ps -q)
docker build -t aphrodite-api-br .
sudo docker run --network host --gpus all -e RUN_MODE="local" -p 8000:8000 aphrodite-api-br
