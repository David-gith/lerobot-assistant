---
name: lerobot-assistant
description: LeRobot 机器人学习助手与环境配置工具。当用户遇到以下任何场景时使用此 Skill：(1) LeRobot 安装与环境配置（conda、pip、依赖安装、ffmpeg）(2) 机器人硬件连接与校准（SO-101、Koch、Aloha、Unitree 等）(3) 数据集录制与可视化（teloperation、record、HF Hub）(4) 策略训练与部署（imitation learning、reinforcement learning）(5) 仿真环境配置（Aloha、PushT）(6) 常见问题排查与故障诊断。触发关键词：LeRobot、lerobot、huggingface、机器人、teloperate、record、calibrate、训练、policy、数据集、Hub、安装、ffmpeg、conda、SO101、Koch、Aloha、Unitree。
---

# LeRobot 机器人学习助手

集成环境检测、交互式安装引导和知识库检索三大能力，覆盖 LeRobot 机器人学习全生命周期。

**知识库路径**：`{BASE_DIR}/references/knowledge/`
**环境检测脚本**：`{BASE_DIR}/scripts/env_check.sh`
**配置文件**：`{BASE_DIR}/config.yaml`
> 其中 `{BASE_DIR}` 为本 skill 加载时顶部显示的 "Base directory for this skill" 路径。

---

## 环境感知

在回答问题前，先判断用户当前所处环境：

| 信号 | 判断方法 | 结论 | 影响 |
|------|----------|------|------|
| Python 版本 < 3.12 | `python --version` | **Python 版本过低** | 需创建新环境 |
| conda/mamba 未安装 | `command -v conda \|\| command -v mamba` | **缺少环境管理器** | 引导安装 miniforge |
| 已安装 lerobot | `python -c "import lerobot"` | **已安装** | 跳过安装，直接引导使用 |
| 未安装 lerobot | `python -c "import lerobot"` 失败 | **未安装** | 引导完整安装流程 |
| Windows 系统 | `uname -a` 或检查 OS | **Windows** | 建议 WSL2 或说明限制 |

---

## 问题分流

收到用户请求后，先判断走哪条流程：

| 问题类型 | 执行流程 |
|---------|---------|
| 安装 LeRobot、配置环境、安装依赖 | → 流程 A（安装引导） |
| `/lerobot-env` | → 流程 A（完整流程：检测 → 安装 → 验证） |
| `/lerobot-env check` | → 流程 A Step 1（仅检测） |
| `/lerobot-env install` | → 流程 A Step 2（跳过检测，直接安装缺失项） |
| `/lerobot-env diagnose` 或安装报错 | → 流程 A Step 6（故障诊断） |
| **训练报错、PyTorch/GPU 问题** | → 先查高频快答，未命中则流程 B 检索 `09_FAQ故障排查/` |
| **机器人连接、无法校准** | → 先查速查卡片「硬件连接与校准」；未命中则流程 B 检索 |
| **策略训练（ACT/SmolVLA/π₀等）** | → 流程 B 检索 `02_策略/`、`04_训练部署/` |
| 数据集录制、HF Hub 上传问题 | → 流程 B 检索 `01_数据集/` |
| 仿真环境问题 | → 流程 B 检索 `05_模拟/` |
| 版本问题 | → 高频快答「版本检查」 |

---

## 高频问题快答

以下问题无需检索知识库，直接回答：

| 问题 | 快速回答 |
|------|---------|
| LeRobot 怎么安装（稳定版 v0.5.1） | `pip install lerobot==0.5.1` |
| LeRobot 怎么安装（开发版/源码） | `git clone https://github.com/huggingface/lerobot.git && cd lerobot && pip install -e ".[aloha,pusht,feetech]"` |
| 怎么检查当前版本 | `python -c "import lerobot; print(lerobot.__version__)"` |
| ffmpeg 安装失败 | Linux: `sudo apt install ffmpeg`；conda: `conda install -c conda-forge ffmpeg` |
| Python 版本要求 | Python >= 3.12（推荐 3.12） |
| PyTorch 版本要求 | PyTorch >= 2.10 |
| 怎么连接 SO-101 机器人 | 先安装 Feetech SDK：`pip install -e ".[feetech]"`；然后找到 USB 端口：`ls /dev/tty.usb*`（macOS）或 `ls /dev/ttyUSB*`（Linux）；运行校准：`lerobot-calibrate --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot` |
| 怎么录制数据集 | 遥操作测试：`lerobot-teleoperate --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot --teleop.type=so101_leader --teleop.port=/dev/ttyUSB1 --teleop.id=my_leader`；录制：`lerobot-record --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot --fps 30 --repo-id YOUR_USER/robot_dataset` |
| 怎么上传数据集到 HF Hub | 确保登录：`huggingface-cli login`；录制时加 `--dataset.push_to_hub=true`；或手动：`python -c "from lerobot import LeRobotDataset; ds.push_to_hub('your_user/dataset_name')"` |
| 怎么训练策略（ACT） | `lerobot train --repo-id YOUR_USER/robot_dataset --policy.type=act --device=cuda` |
| 怎么训练策略（SmolVLA） | `lerobot train --repo-id YOUR_USER/robot_dataset --policy.type=smolvla --device=cuda` |
| 怎么评估策略 | `lerobot evaluate --repo-id YOUR_USER/robot_dataset --checkpoint=checkpoint_latest --device=cuda` |
| 怎么使用预训练模型 | `lerobot evaluate --repo-id lerobot/smolvla_vlabench --device=cuda` |
| Koch 机械臂怎么安装 | `pip install -e ".[dynamixel]"`；Ubuntu 需要 ffmpeg：`conda install -c conda-forge ffmpeg && pip uninstall opencv-python && conda install -c conda-forge "opencv>=4.10.0"` |
| Windows 上能用 LeRobot 吗 | 建议使用 WSL2；原生 Windows 支持有限，主要用于模拟和数据处理 |
| 怎么查看支持的机器人 | 查看 `references/knowledge/06_机器人硬件/` 或访问文档 |
| 怎么用 LoRA 微调 | `lerobot train --repo-id USER/dataset --policy.type=act --policy.use_lora=true` |
| 多 GPU 训练怎么做 | `lerobot train --repo-id USER/dataset --training.num_workers=4 --device=cuda` |

---

## 速查卡片

以下是高频但信息量大的操作，单独列出便于快速定位。

### 硬件连接与校准

#### SO-101 机器人连接流程

```bash
# 1. 安装 LeRobot 和 Feetech SDK
pip install -e ".[feetech]"

# 2. 查找 USB 端口
# Linux:
ls /dev/ttyUSB*
# macOS:
ls /dev/tty.usb*

# 3. 校准 Follower（执行器）
lerobot-calibrate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_awesome_robot

# 4. 校准 Leader（遥控器）
lerobot-calibrate \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_awesome_leader

# 5. 开始遥操作
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_awesome_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_awesome_leader \
    --display_data=true
```

#### Koch 机械臂连接流程

```bash
# 1. 安装 Dynamixel SDK
pip install -e ".[dynamixel]"

# 2. 安装 ffmpeg（Linux）
conda install -c conda-forge ffmpeg
pip uninstall opencv-python
conda install -c conda-forge "opencv>=4.10.0"

# 3. 校准
lerobot-calibrate --robot.type=koch_follower --robot.port=/dev/ttyUSB0 --robot.id=my_koch
lerobot-calibrate --teleop.type=koch_leader --teleop.port=/dev/ttyUSB1 --teleop.id=my_koch_leader

# 4. 遥操作
lerobot-teleoperate --robot.type=koch_follower --robot.port=/dev/ttyUSB0 --robot.id=my_koch --teleop.type=koch_leader --teleop.port=/dev/ttyUSB1 --teleop.id=my_koch_leader
```

### 数据录制与 Hub 上传

```bash
# 遥操作录制数据集
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_leader \
    --fps 30 \
    --repo-id ${HF_USER}/my_dataset \
    --tags tutorial \
    --warmup-time-s 5 \
    --episode-time-s 60 \
    --reset-time-s 30 \
    --num-episodes 50 \
    --push-to-hub=true

# 参数说明：
# --fps: 帧率（推荐 30）
# --episode-time-s: 每个 episode 的时长（秒）
# --num-episodes: 录制 episode 数量
# --push-to-hub: 是否自动上传到 HF Hub
```

### 训练与评估

```bash
# 训练策略（ACT 算法）
lerobot train \
    --repo-id YOUR_USER/my_dataset \
    --policy.type=act \
    --device=mps  # macOS
    # 或 --device=cuda  # Linux with GPU

# 评估策略
lerobot evaluate \
    --repo-id YOUR_USER/my_dataset \
    --checkpoint=checkpoint_latest

# 使用预训练模型
lerobot evaluate \
    --repo-id lerobot/smolvla_vlabench \
    --device=cuda
```

---

## 典型工作流

用户在 LeRobot 开发中最常见的端到端流程：

### 工作流 1：首次上手（稳定版 v0.5.1）

```
pip install lerobot==0.5.1
  → python -c "import lerobot; print(lerobot.__version__)"  # 验证版本
  → lerobot evaluate --repo-id lerobot/pusht  # 快速测试
```

### 工作流 2：开发版安装（从源码）

```
conda create -n lerobot python=3.12 -y
conda activate lerobot
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht,feetech]"
conda install -c conda-forge ffmpeg
  → 连接机器人硬件
  → lerobot-calibrate 校准
  → lerobot-teleoperate 遥操作测试
  → lerobot-record 录制数据集
  → 手动上传到 HF Hub（如未设置自动上传）
```

### 工作流 2：使用仿真环境（无需硬件）

```
conda create -n lerobot python=3.12 -y
conda activate lerobot
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht]"

  → 下载预训练数据集
  → lerobot train 训练
  → lerobot evaluate 评估
```

### 工作流 3：使用预训练模型

```
pip install lerobot

  → lerobot evaluate --repo-id lerobot/smolvla_vlabench
  → 录制自己的数据集微调
```

---

## 流程 A：安装引导（环境检测 → 安装 → 验证）

### Step 1：环境检测

运行检测脚本，收集系统信息：

```bash
bash {BASE_DIR}/scripts/env_check.sh
```

脚本退出码：**0**=全部通过，**1**=存在警告，**2**=存在失败项。

支持 `--json` 参数输出结构化结果，便于精确解析：
```bash
bash {BASE_DIR}/scripts/env_check.sh --json
```

根据报告对每项标注状态：
- ✅ 通过 — 已满足要求
- ⚠️ 警告 — 非推荐配置但可继续
- ❌ 必须缺失 — 必须安装才能继续

如果所有必须项均通过，提示用户可进入下一步。如果是 `/lerobot-env check` 命令触发，到此结束。

### Step 2-5：交互式安装

按 LeRobot 标准安装流程引导，每步执行前需用户确认。

安装顺序：
1. **miniforge**（如需）— 使用 conda 环境管理
2. **Python 环境** — `conda create -n lerobot python=3.12 -y`
3. **LeRobot** — `pip install -e ".[aloha,pusht]"` 或从源码安装
4. **ffmpeg**（Linux）— `conda install -c conda-forge ffmpeg`
5. **硬件 SDK** — 根据机器人类型安装对应驱动
6. **验证** — `python -c "import lerobot; print(lerobot.__version__)"`

LeRobot 特有步骤（按需引导）：
- 仿真环境安装（gym-aloha、gym-pusht）
- 硬件驱动安装（Feetech SDK、Dynamixel SDK）
- HF Hub 登录配置
- 预训练模型下载

### Step 6：故障诊断

当用户调用 `/lerobot-env diagnose` 或安装过程中遇到错误时：

1. 先运行环境检测脚本获取当前状态
2. 在知识库 `07_FAQ故障排查/` 目录中检索匹配的错误信息
3. 详细诊断表见 `{BASE_DIR}/USAGE.md` 第七章节

所有修复命令需用户确认后才执行。

---

## 流程 B：知识库检索

### Step 1：识别问题类型，确定搜索目录

**优先按机器人类型匹配文件名**：LeRobot 支持多种机器人，先用 Glob 按文件名搜索。例如用户问"S101 校准"，直接 `Glob("*so101*")` 在 knowledge 目录下匹配，命中则直接读取，跳过 Grep。

文件名未命中时，参考下表缩小 Grep 搜索范围：

| 问题类型 | 优先目录 |
|---------|---------|
| 安装、conda、pip、ffmpeg、**系统怎么安装** | `00_开始使用/01_安装指南.md`、`09_FAQ故障排查/` |
| 版本检查、稳定版 vs 开发版 | 高频快答「版本检查」 |
| PyTorch 报错、CUDA/GPU 问题、训练失败 | `09_FAQ故障排查/`、`00_开始使用/09_多GPU训练.md` |
| **机器人连接、端口找不到、无法校准** | `06_机器人硬件/校准指南/`、`09_FAQ故障排查/` |
| teloperation、遥操作、键盘控制 | `07_遥操作员/遥操作指南.md` |
| 数据集录制、HF Hub 上传 | `01_数据集/使用LeRobotDataset.md`、`00_开始使用/03_机器人的模仿学习.md` |
| 策略训练、ACT、SmolVLA、π₀、GR00T | `02_策略/`、`04_训练部署/策略训练指南.md` |
| SO-101、Koch、Reachy 2、Unitree G1 特定问题 | `06_机器人硬件/特定机器人指南/` |
| 仿真环境（PushT、Aloha、LeIsaac、IsaacLab） | `05_模拟/`、`00_开始使用/08_模拟中训练强化学习.md` |
| 预训练模型、微调、LoRA | `02_策略/`、`00_开始使用/10_PEFT微调.md` |
| 处理器开发、自定义硬件 | `05_机器人处理器/` |
| 摄像头配置、多相机 | `08_摄像头/` |
| 异步推理、实时分块 RTC | `03_推理/` |

### Step 2：用 Grep 工具检索（禁止使用 Bash grep）

使用内置 **Grep 工具**在 `{BASE_DIR}/references/knowledge/` 中检索：

- **先搜文件列表**：在对应子目录中搜关键词，找到最相关的 1-3 个文件名
- **再搜内容**：用 `-C 3`（上下文）精准定位段落
- **多关键词重试**：例如 "安装" → "install"、"setup"；"报错" → "error"、"failed"
- **仍无结果**：扩大到 `07_FAQ故障排查/` 全目录兜底搜索

### Step 3：读取文件并回答

读取命中文件时注意：
- 文件超 200 行先用 Grep 定位具体章节，再按需分段读取
- 读取后**直接给出解决步骤和命令**，不绕弯

**回答格式要求**：
1. FAQ / 报错类 → 「症状 → 原因 → 命令」三段式
2. 硬件连接类 → 连接步骤 + 配置片段
3. 训练类 → 核心命令 + 参数说明
4. 每条回答末尾注明来源：`（来源：文件名.md）`
5. 若多个文件有相关内容，逐一引用并综合

### Step 4：未找到时的处理

若多轮 Grep 仍无结果：
1. 换同义词再试一次
2. 仍无结果 → 基于 LeRobot/Hugging Face 领域知识作答，并说明「本地知识库未找到直接记录」

---

## 重要约束

- **sudo 操作必须确认**：所有涉及 `sudo` 的命令，必须先展示给用户，得到确认后再执行
- **不跳过步骤**：安装流程严格按顺序执行，不跳过环境检测
- **幂等性**：每步执行前先检测是否已完成（通过 env_check.sh），已安装的自动跳过
- **Python 版本要求**：必须 Python >= 3.12，不支持更低版本
- **硬件支持说明**：LeRobot 主要支持 Linux/macOS，Windows 建议 WSL2
- **GPU 推荐**：训练建议使用 NVIDIA GPU（8GB+ VRAM），macOS 可用 MPS
- **ffmpeg 重要性**：Linux 仿真环境必须安装 ffmpeg，否则视频录制会失败

## 知识库目录结构（快速参考）

见 `{BASE_DIR}/references/knowledge_index.md`

## 文件结构

```
lerobot-assistant/
├── _meta.json               # 元数据
├── config.yaml              # 版本要求和 URL 配置（单一事实来源）
├── SKILL.md                 # 技能定义（本文件）
├── USAGE.md                 # 详细使用手册
├── scripts/
│   └── env_check.sh         # 环境检测脚本（支持 --json 输出）
└── references/
    ├── knowledge_index.md   # 知识库索引
    └── knowledge/           # 知识库文档（11 个子目录）
        ├── 00_开始使用/      # 安装、快速入门、模仿学习、RL、PEFT
        ├── 01_数据集/       # LeRobotDataset、移植、工具
        ├── 02_策略/         # ACT、SmolVLA、π₀ 系列、GR00T 等
        ├── 03_推理/         # 异步推理、RTC
        ├── 04_模拟/         # Hub 环境、LeIsaac、IsaacLab、Libero、MetaWorld
        ├── 05_机器人处理器/  # 处理器概念、调试、自定义实现
        ├── 06_机器人硬件/    # 8 种机器人快速入门、校准
        ├── 07_遥操作员/      # 遥操作指南、键盘控制
        ├── 08_摄像头/        # 配置、多摄像头、校准
        ├── 09_PyTorch加速器/ # CUDA、MPS、设备管理
        ├── 10_资源与工具/     # Notebooks、Hub 资源
        └── 11_关于/          # 贡献指南、向后兼容
```