#!/bin/bash
git pull
sudo docker ps --format "{{.ID}} {{.Image}}" | grep "aphrodite" | awk '{print $1}' | xargs sudo docker stop
docker build -t aphrodite-api-l3lexi .
sudo docker run --network host --gpus all -p 8000:8000 aphrodite-api-l3lexi local
