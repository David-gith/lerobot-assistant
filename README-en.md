# LeRobot Assistant Skill

![LeRobot Assistant Skill](assets/hero-lab-workflow.png)

[中文说明](README-ch.md)

`lerobot-assistant` is an Agent Skill for LeRobot robotics workflows. It helps an AI agent diagnose local environments, retrieve LeRobot v0.5.1 knowledge, guide SO-101/S101 setup, and produce safer step-by-step commands for installation, teleoperation, dataset recording, training, and troubleshooting.

The repository is structured like a self-contained skill folder: the root contains `SKILL.md`, with scripts, templates, tests, and references bundled next to it.

## What It Does

- Detects Python, conda/mamba, Git, LeRobot, PyTorch, GPU, ffmpeg, USB serial devices, and Hugging Face CLI readiness.
- Routes LeRobot questions to a local 58-file knowledge base derived from the Hugging Face LeRobot v0.5.1 docs.
- Provides a renderable SO-101/S101 configuration template.
- Gives safety-aware guidance for hardware, `sudo`, package installs, Hub uploads, firmware, and long-running training.
- Includes pytest and shell tests so the skill can be validated before publishing or installing.

## Skill Layout

```text
lerobot-assistant/
├── SKILL.md                    # Required skill entry point
├── README.md
├── README-ch.md
├── LICENSE
├── SECURITY.md
├── THIRD_PARTY_NOTICES.md
├── config.yaml                 # Version, URL, install profile, robot metadata
├── pyproject.toml              # pytest config
├── requirements-dev.txt
├── assets/                     # README illustrations
├── scripts/
│   ├── env_check.sh            # Human/JSON environment diagnostics
│   └── render_so101_config.py  # SO-101/S101 template renderer
├── templates/
│   └── so101_config.yaml
├── references/
│   ├── knowledge_index.md
│   └── knowledge/              # 58 local knowledge files
└── tests/
    ├── test_env_check.py
    ├── test_project_metadata.py
    ├── test_so101_template.py
    └── shell_env_check.sh
```

## Install As A Skill

For Claude or other Agent Skills-compatible clients, install or upload this repository folder as a custom skill. The required entry point is:

```text
SKILL.md
```

The skill itself does not require a dedicated Python environment to be loaded. Python is only needed when running bundled diagnostics, tests, or real LeRobot commands.

## LeRobot Runtime Environment

For real LeRobot usage, use a clean Python 3.12 environment:

```bash
conda create -n lerobot python=3.12 -y
conda activate lerobot
pip install "lerobot[all]==0.5.1"
```

For source development:

```bash
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[all]"
```

## Environment Diagnostics

```bash
bash scripts/env_check.sh
bash scripts/env_check.sh --json
```

Exit status:

- `0`: all checks passed.
- `1`: warnings exist, but lightweight workflows may continue.
- `2`: required issue exists, usually Python missing or below 3.12.

## SO-101/S101 Template

![SO-101 validation](assets/so101-validation.png)

Render the bundled configuration template:

```bash
python3 scripts/render_so101_config.py \
  --robot-id demo_so101 \
  --robot-port /dev/ttyUSB0 \
  --teleop-port /dev/ttyUSB1 \
  --dataset-repo-id USER/so101_dataset
```

## Common LeRobot Commands

```bash
# Teleoperate SO-101
lerobot-teleoperate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyUSB0 \
  --robot.id=my_so101 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyUSB1 \
  --teleop.id=my_so101_leader

# Record a small dataset
lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyUSB0 \
  --robot.id=my_so101 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyUSB1 \
  --teleop.id=my_so101_leader \
  --dataset.repo_id=USER/so101_test \
  --dataset.num_episodes=5

# Train ACT
lerobot-train \
  --dataset.repo_id=USER/so101_test \
  --policy.type=act \
  --policy.device=cuda
```

## Sim-First Evaluation Before Real Robot Tests

![Simulation to real workflow](assets/workflow-sim2real.png)

For most robot-learning workflows, evaluate policies in simulation before running them on a real SO-101/S101 arm. This skill includes local references for both LIBERO and Meta-World:

- LIBERO: `references/knowledge/04_模拟/04_LIBERO.md`
- Meta-World: `references/knowledge/04_模拟/05_MetaWorld.md`

A conservative evaluation loop is:

1. Run `bash scripts/env_check.sh --json` and fix required failures.
2. Train or load a policy using a dataset compatible with your target robot task.
3. Validate the policy in LIBERO or Meta-World with short runs first.
4. Inspect success rate, failure modes, video output, action scale, and observation/action fields.
5. Only after simulation smoke tests pass, run a short low-speed SO-101/S101 hardware validation.
6. Keep `push_to_hub` disabled until dataset privacy and repository permissions are confirmed.

Example simulation-oriented commands vary by LeRobot environment and installed benchmark dependencies. Use these as workflow anchors rather than copy-paste guarantees:

```bash
# Install LeRobot with broad optional dependencies for local experiments.
pip install "lerobot[all]==0.5.1"

# Read the local benchmark notes before running a benchmark.
sed -n '1,160p' references/knowledge/04_模拟/04_LIBERO.md
sed -n '1,160p' references/knowledge/04_模拟/05_MetaWorld.md

# Keep the first evaluation short and inspect logs/videos before hardware tests.
lerobot-record --help
lerobot-train --help
```

When moving from simulation to SO-101/S101, verify camera names, action dimensions, normalization statistics, control frequency, joint limits, and emergency stop behavior. Do not run an unvalidated simulation policy directly on hardware.

## Test

```bash
python3 -m pip install -r requirements-dev.txt
python3 -m pytest
bash tests/shell_env_check.sh
```

The tests validate:

- `SKILL.md` references existing bundled assets.
- Environment JSON output is machine-readable.
- Knowledge index coverage matches the bundled 58 knowledge files.
- Every knowledge file has a source marker.
- SO-101/S101 template rendering works.

## Security

This repository should not contain credentials or private robot configuration. The bundled diagnostics are read-only, and the SO-101/S101 template defaults to `push_to_hub: false`.

Before publishing changes, review [SECURITY.md](SECURITY.md) and run the listed secret/dangerous-command scans.

## Sources

The local knowledge base is based on:

- Hugging Face LeRobot docs index: https://huggingface.co/docs/lerobot/index
- LeRobot v0.5.1 documentation pages.
- Hugging Face LeRobot GitHub repository: https://github.com/huggingface/lerobot

This repository is not affiliated with Hugging Face or the LeRobot maintainers.

## Publishing Checklist

Before uploading to GitHub:

```bash
git status --short
python3 scripts/security_scan.py
python3 -m pytest
bash tests/shell_env_check.sh
```

Do not commit generated caches such as `__pycache__/` or `.pytest_cache/`.
