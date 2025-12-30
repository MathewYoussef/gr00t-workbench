#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="${ISAAC_GR00T_DIR:-${ROOT_DIR}/../Isaac-GR00T}"
ref="${ISAAC_GR00T_REF:-}"

if [[ -d "${target_dir}/.git" ]]; then
  echo "Already exists: ${target_dir}"
  exit 0
fi

mkdir -p "$(dirname -- "${target_dir}")"
git clone --recursive https://github.com/NVIDIA/Isaac-GR00T.git "${target_dir}"

if [[ -n "${ref}" ]]; then
  git -C "${target_dir}" checkout "${ref}"
  git -C "${target_dir}" submodule update --init --recursive
fi

echo "Cloned Isaac-GR00T to: ${target_dir}"

