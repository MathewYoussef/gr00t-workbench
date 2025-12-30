#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

JETSON_CONTAINERS_DIR="${JETSON_CONTAINERS_DIR:-${ROOT_DIR}/../jetson-containers}"
JETSON_IMAGE_NAME="${JETSON_IMAGE_NAME:-isaac-gr00t}"

if [[ ! -x "${JETSON_CONTAINERS_DIR}/build.sh" ]]; then
  echo "ERROR: jetson-containers build.sh not found/executable at: ${JETSON_CONTAINERS_DIR}/build.sh" >&2
  exit 1
fi

echo "Using jetson-containers: ${JETSON_CONTAINERS_DIR}"
echo "Building image: ${JETSON_IMAGE_NAME}"

exec "${JETSON_CONTAINERS_DIR}/build.sh" --name "${JETSON_IMAGE_NAME}" isaac-gr00t "$@"

