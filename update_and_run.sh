#!/bin/bash
git pull
sudo docker stop $(sudo docker ps -q)
docker build -t aphrodite-api-l3 .
sudo docker run --network host --gpus all -p 8000:8000 aphrodite-api-l3 local
