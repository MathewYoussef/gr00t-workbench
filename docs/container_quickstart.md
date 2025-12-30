# Container quickstart

This repo standardizes a few conventions:

- Isaac-GR00T is bind-mounted into the container at `/workspace/Isaac-GR00T`
- Hugging Face cache lives on a data disk (recommended) via `HF_HOME=/mnt/nvme1/hf_cache_root`
- Datasets and checkpoints live on the data disk so containers stay disposable

## Host prerequisites

- Docker installed and usable by your user
- NVIDIA Container Toolkit installed
- `nvidia-smi` works on the host

## Recommended host layout

- Code:
  - `../Isaac-GR00T` (sibling to this repo)
- Data disk:
  - `/mnt/nvme1/hf_cache_root` (HF cache)
  - `/mnt/nvme1/datasets`
  - `/mnt/nvme1/checkpoints`

## Run

From `gr00t-workbench/`:
```bash
cp .env.example .env
./scripts/run_container.sh
```

Or with compose:
```bash
cp .env.example .env
docker compose run --rm gr00t
```

## First-time setup inside the container

```bash
nvidia-smi
cd /workspace/Isaac-GR00T
bash docker/setup_blackwell_env.sh
```

## Model weights

Weights are downloaded from Hugging Face Hub and cached under `HF_HOME`.

Keep `HF_HOME` pointing at the data disk so re-runs don’t redownload.

