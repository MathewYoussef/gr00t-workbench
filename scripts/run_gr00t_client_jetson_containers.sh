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
ISAAC_GR00T_DIR="${ISAAC_GR00T_DIR:-${ROOT_DIR}/../Isaac-GR00T}"
HF_HOME="${HF_HOME:-/data/models/huggingface}"

if [[ ! -x "${JETSON_CONTAINERS_DIR}/run.sh" ]]; then
  echo "ERROR: jetson-containers run.sh not found/executable at: ${JETSON_CONTAINERS_DIR}/run.sh" >&2
  exit 1
fi

if [[ ! -d "${ISAAC_GR00T_DIR}" ]]; then
  echo "ERROR: ISAAC_GR00T_DIR not found: ${ISAAC_GR00T_DIR}" >&2
  exit 1
fi

# Prefer autotag if available (this is how we usually get $IMG)
IMG=""
if [[ -x "${JETSON_CONTAINERS_DIR}/autotag" ]]; then
  IMG="$("${JETSON_CONTAINERS_DIR}/autotag" isaac-gr00t 2>/dev/null || true)"
fi

# Fallback to the named image if autotag isn't available or returned empty
if [[ -z "${IMG}" ]]; then
  IMG="${JETSON_IMAGE_NAME:-isaac-gr00t}"
fi

echo "Using image: ${IMG}"
echo "Mounting Isaac-GR00T: ${ISAAC_GR00T_DIR} -> /opt/Isaac-GR00T"
echo "HF_HOME: ${HF_HOME}"

exec "${JETSON_CONTAINERS_DIR}/run.sh" \
  --name gr00t-client \
  --hostname gr00t-client \
  --entrypoint /bin/bash \
  -e "HF_HOME=${HF_HOME}" \
  -e NO_ALBUMENTATIONS_UPDATE=1 \
  -v "${ISAAC_GR00T_DIR}:/opt/Isaac-GR00T" \
  -w /opt/Isaac-GR00T \
  "${IMG}" \
  "$@"

