# Runbook (detailed)

This is the “source of truth” for our GR00T container workflow: mounts, cache conventions, and repeatable commands.

## Host prerequisites

- Working NVIDIA driver (`nvidia-smi` on the host)
- Docker Engine + NVIDIA Container Toolkit

### NVIDIA runtime notes

Even if your Docker daemon has NVIDIA support, we explicitly pass `--runtime=nvidia` in `docker run` to avoid falling back to `runc` on some hosts.

If you need to register the runtime, a minimal `daemon.json` looks like:
```bash
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "args": []
    }
  }
}
EOF
sudo systemctl restart docker
```

Sanity check:
```bash
docker run --rm --runtime=nvidia --gpus all --ipc=host nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

## Host layout conventions

- Isaac-GR00T checkout on host: `ISAAC_GR00T_DIR` (recommended `../Isaac-GR00T`)
- Data disk on host: `DATA_DIR` (recommended `/mnt/nvme1`)
- HF cache: `HF_HOME=/mnt/nvme1/hf_cache_root`

These are wired into:

- `./scripts/run_container.sh` (docker run)
- `compose.yaml` (docker compose)

## Launch the container (docker run)

From `gr00t-workbench/`:
```bash
cp .env.example .env
./scripts/run_container.sh
```

## Inside the container (first-time per host checkout)

```bash
nvidia-smi
cd /workspace/Isaac-GR00T
bash docker/setup_blackwell_env.sh
```

If your base image doesn’t include basic utilities, install them per-container (containers are disposable):
```bash
apt-get update && apt-get install -y tmux ffmpeg
```

## Download model weights (cached under HF_HOME)

Weights come from Hugging Face Hub and cache under `HF_HOME` (which should point at the mounted data disk):
```bash
cd /workspace/Isaac-GR00T
.venv/bin/python - <<'PY'
from huggingface_hub import snapshot_download
p = snapshot_download("nvidia/GR00T-N1.6-3B")
print("Cached at:", p)
PY
```

## Persistence model (what survives container exit)

- The repo checkout is on the host (bind-mounted) → persists
- The HF cache is on the data disk (`HF_HOME`) → persists
- Checkpoints/datasets are on the data disk (`DATA_DIR`) → persists
- The container filesystem is disposable → do not store important state there

