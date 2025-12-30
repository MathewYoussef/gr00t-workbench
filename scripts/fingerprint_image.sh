#!/usr/bin/env bash
set -euo pipefail

image="${1:-isaac-gr00t:r38.3.arm64-sbsa-cu130-24.04}"

echo "IMAGE: ${image}"
docker image inspect "${image}" --format \
  $'Id={{.Id}}\nCreated={{.Created}}\nOs={{.Os}} Arch={{.Architecture}}\nSize={{.Size}}\nRepoTags={{json .RepoTags}}'

echo
echo "FINGERPRINT (Id + RootFS layers sha256):"
docker image inspect "${image}" --format '{{.Id}}{{"\n"}}{{range .RootFS.Layers}}{{println .}}{{end}}' | sha256sum

