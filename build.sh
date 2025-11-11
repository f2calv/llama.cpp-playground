#!/bin/bash

REGISTRY="ghcr.io/f2calv"
REPOSITORY="llama-cpp"
TAG="latest"
PLATFORM="linux/arm64"

docker buildx create --name llamacpp1 --use

docker buildx build -t "$REGISTRY/$REPOSITORY:$TAG" \
    --platform $PLATFORM \
    --pull \
    .
