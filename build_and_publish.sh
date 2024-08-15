#!/bin/bash

# Pull the latest code from the repository
git pull

# Build the Docker image
docker build -t aphrodite-api-l3 .

# Check if the user is logged in to Docker
if ! docker info >/dev/null 2>&1; then
    echo "Docker login required"
    docker login
else
    echo "Already logged in to Docker"
fi

IMAGE_TAG="gzmagyari/aphrodite-api-l3:latest"
docker tag aphrodite-api-l3 $IMAGE_TAG

# Push the Docker image to Docker Hub
docker push $IMAGE_TAG
