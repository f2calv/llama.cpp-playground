Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

$REGISTRY = "ghcr.io/f2calv"
$REPOSITORY = "llama-cpp"
$TAG = "latest"
$PLATFORM = "linux/arm64"

#https://github.com/docker/buildx/issues/94#issuecomment-534831828
& "docker" buildx create --name knx1 --use

& "docker" buildx build -t "$REGISTRY/$($REPOSITORY):$TAG" `
    --platform $PLATFORM `
    --pull `
    .
