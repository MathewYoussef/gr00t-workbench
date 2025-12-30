# gr00t-workbench

Reproducible container recipes, runbooks, and scripts for running and fine-tuning NVIDIA Isaac-GR00T.

This repo intentionally does **not** vendor model weights/datasets, and does **not** redistribute container images. Instead, it provides a repeatable “source of truth” for how to run the environment (mounts, cache paths, commands, and version pins).

## What you bring

- An Isaac-GR00T checkout (recommended location: `../Isaac-GR00T`)
- A data disk directory (recommended: `/mnt/nvme1`) for:
  - Hugging Face cache (`HF_HOME`)
  - datasets
  - checkpoints/outputs
- Docker + NVIDIA Container Toolkit working on the host

## Quickstart

1) Clone Isaac-GR00T next to this repo (or set `ISAAC_GR00T_DIR`):
```bash
./scripts/clone_isaac_gr00t.sh
```

2) Copy env template and edit paths if needed:
```bash
cp .env.example .env
```

3) Start a shell in the container:
```bash
./scripts/run_container.sh
```

4) Inside the container, set up the repo environment (one-time per host checkout):
```bash
cd /workspace/Isaac-GR00T
bash docker/setup_blackwell_env.sh
```

See `docs/container_quickstart.md` for details and troubleshooting.

## Where the “recipe” is

- `scripts/run_container.sh` (the canonical `docker run ...` with mounts/env)
- `compose.yaml` (the same configuration via Docker Compose)

## Docs

- `docs/container_quickstart.md` (how to start the container)
- `docs/data_layout.md` (what lives on the data disk)
- `docs/runbook.md` (detailed runbook, based on our local setup)
- `docs/smoke_tests.md` (GPU + image fingerprint checks)
