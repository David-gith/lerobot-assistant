---
name: lerobot-assistant
description: Use this skill for LeRobot robotics learning tasks: installing or diagnosing LeRobot environments, checking Python/PyTorch/ffmpeg/GPU/USB readiness, configuring SO-101/S101 arms, calibrating or teleoperating robots, recording datasets, training/evaluating ACT or SmolVLA policies, using Hugging Face Hub resources, and troubleshooting LeRobot errors. Trigger on LeRobot, lerobot, Hugging Face robotics, SO101/S101, SO-101, teleoperate, calibrate, record, dataset, ACT, SmolVLA, PushT, Aloha, Feetech, Dynamixel, ffmpeg, CUDA, PyTorch, or robot imitation learning.
---

# LeRobot Assistant

Help users move through LeRobot workflows with local diagnostics, targeted knowledge retrieval, and safe command execution.

## Resources

- Environment checker: `scripts/env_check.sh`
- Configuration source: `config.yaml`
- Knowledge index: `references/knowledge_index.md`
- Knowledge files: `references/knowledge/`
- SO-101/S101 template: `templates/so101_config.yaml`

Use the skill base directory shown by Codex when resolving these relative paths.

## Core Workflow

1. Classify the request.
2. Use a quick answer only for stable, high-confidence commands.
3. Otherwise inspect the local knowledge index and read the smallest relevant knowledge file.
4. For environment problems, run `bash scripts/env_check.sh --json` when local execution is useful.
5. Give concrete next steps and commands. Mention the local source file used.
6. Ask before running commands that install packages, use `sudo`, access hardware, modify shell startup files, or upload to Hugging Face Hub.

## Python Environment Policy

This skill itself does not require a dedicated Python environment to be loaded or used. A dedicated environment is recommended for development, testing, and real LeRobot usage:

```bash
conda create -n lerobot python=3.12 -y
conda activate lerobot
```

For project tests, use any Python that can run `pytest`; the LeRobot runtime should use Python 3.12 and PyTorch compatible with LeRobot v0.5.1/main docs.

## Intent Routing

| User intent | First action |
| --- | --- |
| `/lerobot-env`, install, setup, diagnose | Run or explain `scripts/env_check.sh`; then guide install |
| Python/PyTorch/CUDA/ffmpeg/GPU issue | Read `09_FAQ故障排查/01_常见问题.md` and installation notes |
| SO-101/S101 connection, calibration, USB | Read `06_机器人硬件/01_SO101快速入门.md`; use `templates/so101_config.yaml` |
| Teleoperation or keyboard control | Read `07_遥操作员/01_遥操作指南.md` |
| Dataset recording, loading, Hub upload | Read `01_数据集/01_使用LeRobotDataset.md` and imitation learning guide |
| Dataset migration/tools/video/subtasks | Read the matching file in `01_数据集/` |
| ACT, SmolVLA, Pi0, Pi0Fast, Pi05, GR00T, X-VLA, WALL-OSS, SARM | Read the matching file in `02_策略/` |
| Async inference or RTC | Read `03_推理/` |
| PushT/Aloha/LeIsaac/LIBERO/Meta-World/IsaacLab simulation | Read `04_模拟/` |
| Processor/custom pipeline/action representation | Read `05_机器人处理器/` |
| Other supported robots | Read the matching file in `06_机器人硬件/` |
| Cameras | Read `08_摄像头/01_摄像头配置.md` |
| CUDA/MPS/PyTorch accelerator | Read `09_PyTorch加速器/01_PyTorch加速器.md` |
| Firmware, CAN bus, notebooks | Read `10_资源与工具/` |
| Compatibility or contribution | Read `11_关于/` |
| Unknown LeRobot question | Search `references/knowledge/` with `rg`, then answer from best match |

## Quick Commands

Use these only when they directly answer the request.

```bash
# Check local readiness
bash scripts/env_check.sh
bash scripts/env_check.sh --json

# Stable PyPI install for common robot workflows
pip install "lerobot[all]"

# Source install for development
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[all]"

# Add common hardware/simulation extras when needed
pip install "lerobot[feetech]"
pip install "lerobot[dynamixel]"
pip install "lerobot[aloha,pusht]"
```

For LeRobot v0.5.1, stable install can be pinned as:

```bash
pip install "lerobot[all]==0.5.1"
```

If extras syntax fails with a pinned package in the user's shell, quote the full spec exactly as shown.

## Environment Diagnosis

Run:

```bash
bash scripts/env_check.sh --json
```

Interpret `overall_status`:

- `0`: ready for normal workflows.
- `1`: warnings exist; continue for lightweight use, fix before hardware/training.
- `2`: required issue exists; fix before installing/running LeRobot.

Required failures usually mean Python is missing or below 3.12. Warnings may include missing LeRobot, PyTorch, GPU, USB device, ffmpeg, or Hugging Face CLI.

## SO-101/S101 Workflow

Treat "S101" as "SO-101" unless the user clearly means a different arm.

1. Confirm OS and USB ports.
2. Install core scripts plus Feetech support.
3. Use `templates/so101_config.yaml` as a configurable local template.
4. Calibrate follower and leader before teleoperation.
5. Record a short smoke-test episode before long dataset collection.

Common commands:

```bash
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null

lerobot-calibrate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyUSB0 \
  --robot.id=my_so101

lerobot-calibrate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyUSB1 \
  --teleop.id=my_so101_leader
```

## Answer Style

- Installation answers: status check → command sequence → validation command.
- Troubleshooting answers: symptom → likely cause → fix commands → validation.
- Hardware answers: port/permission checks → calibration → teleoperation/recording.
- Training answers: dataset check → policy command → resource/GPU note.
- Always include local source references when local knowledge was used, for example: `来源：references/knowledge/06_机器人硬件/01_SO101快速入门.md`.
- If local knowledge is insufficient, say so and use official Hugging Face LeRobot docs or GitHub as the source.

## Safety

- Do not run `sudo`, package installs, firmware changes, device writes, Hub uploads, or long training jobs without user approval.
- Prefer read-only checks first.
- Keep commands idempotent where possible.
- Warn that Windows native support is limited; recommend WSL2 for real LeRobot workflows.
