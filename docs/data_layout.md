# Data layout

The workbench assumes all large, mutable artifacts live outside git on a mounted data disk.

Recommended:

- `DATA_DIR=/mnt/nvme1`
- `HF_HOME=/mnt/nvme1/hf_cache_root`

Suggested folders:

- `/mnt/nvme1/hf_cache_root` (Hugging Face cache)
- `/mnt/nvme1/datasets` (datasets)
- `/mnt/nvme1/checkpoints` (training outputs)

