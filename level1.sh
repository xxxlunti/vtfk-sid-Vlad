set -euo pipefail

docker rm -f vtfk-lab01 >/dev/null 2>&1 || true

docker run -d --name vtfk-lab01 ubuntu:24.04 sleep infinity >/dev/null

docker exec vtfk-lab01 sh -c "echo \"${VTFK_NONCE:-}\" > /tmp/vtfk-nonce"

docker exec vtfk-lab01 sh -c "apt-get update >/dev/null 2>&1 && apt-get install -y procps >/dev/null 2>&1"

CONTAINER_PID=$(docker inspect -f '{{.State.Pid}}' vtfk-lab01)

CONTAINER_PROCS=$(docker exec vtfk-lab01 ps -e --no-headers | wc -l)
HOST_PROCS=$(ps -e --no-headers | wc -l)

echo "CONTAINER_PID: $CONTAINER_PID"
echo "CONTAINER_PROCS: $CONTAINER_PROCS"
echo "HOST_PROCS: $HOST_PROCS"
