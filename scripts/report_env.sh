#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

image="${1:-${GR00T_IMAGE:-}}"
if [[ -z "${image}" ]]; then
  image="isaac-gr00t:r38.3.arm64-sbsa-cu130-24.04"
fi

echo "=== host ==="
echo "date: $(date -Is)"
echo "hostname: $(hostname || true)"
echo "uname: $(uname -a || true)"
command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L || echo "nvidia-smi: (not found)"

echo
echo "=== docker ==="
docker version --format 'client={{.Client.Version}} server={{.Server.Version}}' 2>/dev/null || docker version || true

echo
echo "=== image ==="
echo "image: ${image}"
if ! docker image inspect "${image}" >/dev/null 2>&1; then
  echo "ERROR: image not present locally: ${image}" >&2
  echo "Hint: docker pull/build it, or pass a different image tag to this script." >&2
  exit 1
fi

docker image inspect "${image}" --format \
  $'Id={{.Id}}\nCreated={{.Created}}\nOs={{.Os}} Arch={{.Architecture}}\nSize={{.Size}}\nRepoTags={{json .RepoTags}}'

echo
echo "fingerprint_sha256 (Id + RootFS layers):"
docker image inspect "${image}" --format '{{.Id}}{{"\n"}}{{range .RootFS.Layers}}{{println .}}{{end}}' | sha256sum

echo
echo "=== inside image (best-effort) ==="
docker run --rm --entrypoint bash "${image}" -lc '
set -e
echo "python: $(python -V 2>&1 || true)"
python - <<'"'"'PY'"'"' || true
import sys
print("sys.version:", sys.version.replace("\n", " "))
try:
  import torch
  print("torch:", torch.__version__)
  print("torch cuda:", torch.version.cuda)
except Exception as e:
  print("torch: (unavailable)", repr(e))
PY
if [[ -d /opt/Isaac-GR00T/.git ]]; then
  echo
  echo "/opt/Isaac-GR00T git:"
  (cd /opt/Isaac-GR00T && git rev-parse HEAD && git log -1 --oneline) || true
fi
'

