#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

GR00T_IMAGE="${GR00T_IMAGE:-nvcr.io/nvidia/pytorch:25.11-py3}"
ISAAC_GR00T_DIR="${ISAAC_GR00T_DIR:-${ROOT_DIR}/../Isaac-GR00T}"
DATA_DIR="${DATA_DIR:-/mnt/nvme1}"
HF_HOME="${HF_HOME:-/mnt/nvme1/hf_cache_root}"

if [[ ! -d "${ISAAC_GR00T_DIR}" ]]; then
  echo "ERROR: ISAAC_GR00T_DIR not found: ${ISAAC_GR00T_DIR}" >&2
  echo "Hint: run: ${ROOT_DIR}/scripts/clone_isaac_gr00t.sh" >&2
  exit 1
fi

if [[ ! -d "${DATA_DIR}" ]]; then
  echo "ERROR: DATA_DIR not found: ${DATA_DIR}" >&2
  exit 1
fi

cmd=(/bin/bash)
if [[ $# -gt 0 ]]; then
  cmd=("$@")
fi

exec docker run --rm -it \
  --runtime=nvidia --gpus all \
  --ipc=host \
  --ulimit memlock=-1 --ulimit stack=67108864 \
  -v "${ISAAC_GR00T_DIR}:/workspace/Isaac-GR00T" \
  -v "${DATA_DIR}:/mnt/nvme1" \
  -e "HF_HOME=${HF_HOME}" \
  "${GR00T_IMAGE}" \
  "${cmd[@]}"

