# jetson-containers recipe (custom CUDA-13 isaac-gr00t)

If you’re using the “compiled everything” `isaac-gr00t` image built with `jetson-containers`, the *recipe* lives in the `jetson-containers` repo (for example under `packages/vla/isaac-gr00t/`), not in Isaac-GR00T itself.

This repo (`gr00t-workbench`) stores the **repeatable commands** and **host conventions** so you can do the same thing on thor and desktop without rediscovering flags.

## One-time per machine

Clone both repos as siblings:

- `../jetson-containers`
- `../Isaac-GR00T`
- `gr00t-workbench/`

Copy env template:
```bash
cp .env.example .env
```

Edit `.env` at minimum:

- `JETSON_CONTAINERS_DIR`
- `ISAAC_GR00T_DIR`
- `HF_HOME` (where you want HF cache)

## Build the image (jetson-containers)

From `gr00t-workbench/`:
```bash
./scripts/build_isaac_gr00t_jetson_containers.sh
```

## Run the client shell (jetson-containers)

From `gr00t-workbench/`:
```bash
./scripts/run_gr00t_client_jetson_containers.sh
```

## Compare thor vs desktop

On each machine, run:
```bash
./scripts/report_env.sh isaac-gr00t
```

