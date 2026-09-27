#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${1:-vtfk-lab01}"
IMAGE_NAME="${2:-ubuntu:24.04}"

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME" sleep infinity >/dev/null

if [ -n "${VTFK_NONCE:-}" ]; then
    docker exec "$CONTAINER_NAME" sh -c "echo \"$VTFK_NONCE\" > /tmp/vtfk-nonce"
fi

docker exec "$CONTAINER_NAME" sh -c "apt-get update >/dev/null 2>&1 && apt-get install -y procps >/dev/null 2>&1 || true"

CONTAINER_PID=$(docker inspect -f '{{.State.Pid}}' "$CONTAINER_NAME")

echo "CONTAINER_NAME: $CONTAINER_NAME"
echo "CONTAINER_PID: $CONTAINER_PID"
