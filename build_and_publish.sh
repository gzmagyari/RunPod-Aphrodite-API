#!/bin/bash

# Pull the latest code from the repository
git pull

# Build the Docker image
docker build -t runpod-aphrodite-api-br .

# Check if the user is logged in to Docker
if ! docker info >/dev/null 2>&1; then
    echo "Docker login required"
    docker login
else
    echo "Already logged in to Docker"
fi

IMAGE_TAG="gzmagyari/runpod-aphrodite-api-br:latest"
docker tag runpod-aphrodite-api-br $IMAGE_TAG

# Push the Docker image to Docker Hub
docker push $IMAGE_TAG
