# Smoke tests

## GPU + torch sanity

Run inside the container:
```bash
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.version.cuda)
print("arch list:", torch.cuda.get_arch_list())
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
PY
```

## Image fingerprint (for cross-machine comparison)

On the host:
```bash
./scripts/fingerprint_image.sh isaac-gr00t:r38.3.arm64-sbsa-cu130-24.04
```

