# LeRobot 知识库索引

> **当前版本**：v0.5.1（稳定版）
> **文档地址**：https://huggingface.co/docs/lerobot/v0.5.1/en/index
> **安装方式**：`pip install lerobot==0.5.1`（稳定版）或从源码安装（开发版）
> **版本检查**：`python -c "import lerobot; print(lerobot.__version__)"`

本文档提供 LeRobot 相关知识的快速导航。

---

## 目录结构

```
knowledge/
├── 00_开始使用/
│   ├── 01_安装指南.md              # 从源码安装 / pip 安装
│   ├── 02_快速入门教程.md           # 端到端教程
│   ├── 03_机器人的模仿学习.md        # 遥操作 → 录制 → 训练 → 评估
│   ├── 04_摄像头配置.md             # 添加和管理相机
│   ├── 05_引入您自己的策略.md        # 集成自定义策略
│   ├── 06_引入您自己的硬件.md        # 自定义机器人集成
│   ├── 07_用强化学习训练.md          # RL 训练指南
│   ├── 08_模拟中训练强化学习.md       # Sim-to-Real
│   ├── 09_多GPU训练.md              # 分布式训练
│   └── 10_PEFT微调.md              # LoRA等参数高效微调
│
├── 01_数据集/
│   ├── 01_使用LeRobotDataset.md     # 数据集加载与操作
│   ├── 02_移植大型数据集.md          # 外部数据集迁移
│   └── 03_数据集工具.md             # 可视化与处理工具
│
├── 02_策略/
│   ├── 01_ACT策略.md                # Action Chunking with Transformers
│   ├── 02_SmolVLA.md               # 小型视觉语言动作模型
│   ├── 03_Pi0.md                   # π₀ 基座模型
│   ├── 04_Pi0Fast.md               # π₀-FAST 快速版
│   ├── 05_Pi05.md                  # π₀.₅ 中间版本
│   ├── 06_GR00T_N1.md              # NVIDIA GR00T N1.5
│   ├── 07_X_VLA.md                 # X-VLA 策略
│   ├── 08_WALL_OSS.md              # WALL-OSS 开源策略
│   ├── 09_奖励模型.md               # Reward Model
│   └── 10_SARM.md                  # 传感器融合奖励模型
│
├── 03_推理/
│   ├── 01_异步推理.md               # Async Inference
│   └── 02_实时分块RTC.md            # Real-Time Chunking
│
├── 04_模拟/
│   ├── 01_Hub环境.md               # 来自 Hub 的仿真环境
│   ├── 02_LeIsaac指南.md            # LeIsaac 仿真训练
│   ├── 03_IsaacLab_Arena.md         # NVIDIA IsaacLab 环境
│   ├── 04_Libero.md                # Libero 基准测试
│   └── 05_MetaWorld.md             # MetaWorld 基准测试
│
├── 05_机器人处理器/
│   ├── 01_处理器介绍.md              # Processor 基础概念
│   ├── 02_调试处理器管道.md          # Debug 技巧
│   ├── 03_实现自定义处理器.md         # 自定义处理器开发
│   ├── 04_机器人处理器.md            # Robot 处理器
│   ├── 05_遥操作员处理器.md          # Teleop 处理器
│   └── 06_环境处理器.md              # Env 处理器
│
├── 06_机器人硬件/
│   ├── 01_SO101快速入门.md          # SO-101 机器人
│   ├── 02_SO100快速入门.md          # SO-100 机器人
│   ├── 03_Koch快速入门.md           # Koch v1.1 机械臂
│   ├── 04_LeKiwi指南.md            # LeKiwi 机器人
│   ├── 05_Hope_Jr指南.md           # Hope Jr 机器人
│   ├── 06_Reachy2指南.md           # Reachy 2 机器人
│   ├── 07_Unitree_G1指南.md         # Unitree G1 机器人
│   ├── 08_Earth_Rover_Mini.md      # Earth Rover Mini
│   ├── 09_串口权限设置.md           # USB 权限配置
│   └── 10_校准指南.md              # 机器人校准流程
│
├── 07_遥操作员/
│   ├── 01_遥操作指南.md              # teloperation 基础
│   ├── 02_键盘遥操作.md             # Keyboard teleop
│   └── 03_自定义遥操作.md            # 自定义遥操作设备
│
├── 08_摄像头/
│   ├── 01_摄像头配置.md             # 添加相机
│   ├── 02_多摄像头设置.md            # 多相机同步
│   └── 03_相机校准.md              # 内参标定
│
├── 09_PyTorch加速器/
│   ├── 01_CUDA配置.md              # GPU 训练
│   ├── 02_MPS加速.md               # Apple Silicon MPS
│   └── 03_设备管理.md               # 多设备调度
│
├── 10_资源与工具/
│   ├── 01_Notebooks.md            # Jupyter notebooks
│   └── 02_Hub资源.md               # HF Hub 模型/数据集
│
└── 11_关于/
    ├── 01_贡献指南.md              # 为 LeRobot 贡献
    └── 02_向后兼容.md              # 版本兼容性说明
```

---

## 按主题快速索引

### 快速开始

| 你想做什么 | 文档 |
|-----------|------|
| 首次安装 LeRobot | `00_开始使用/01_安装指南.md` |
| 从零开始录制数据 | `00_开始使用/03_机器人的模仿学习.md` |
| 用仿真环境学习 | `04_模拟/01_Hub环境.md` |
| 查看示例 notebooks | `10_资源与工具/01_Notebooks.md` |

### 机器人硬件

| 机器人型号 | 快速入门文档 |
|-----------|-------------|
| SO-101 | `06_机器人硬件/01_SO101快速入门.md` |
| SO-100 | `06_机器人硬件/02_SO100快速入门.md` |
| Koch v1.1 | `06_机器人硬件/03_Koch快速入门.md` |
| LeKiwi | `06_机器人硬件/04_LeKiwi指南.md` |
| Hope Jr | `06_机器人硬件/05_Hope_Jr指南.md` |
| Reachy 2 | `06_机器人硬件/06_Reachy2指南.md` |
| Unitree G1 | `06_机器人硬件/07_Unitree_G1指南.md` |
| Earth Rover Mini | `06_机器人硬件/08_Earth_Rover_Mini.md` |

### 数据集处理

| 任务 | 文档 |
|------|------|
| 加载已有数据集 | `01_数据集/01_使用LeRobotDataset.md` |
| 录制新数据集 | `00_开始使用/03_机器人的模仿学习.md` |
| 移植外部数据集 | `01_数据集/02_移植大型数据集.md` |
| 可视化数据集 | `01_数据集/03_数据集工具.md` |

### 策略训练

| 策略类型 | 文档 |
|---------|------|
| ACT (Action Chunking) | `02_策略/01_ACT策略.md` |
| SmolVLA (视觉语言动作) | `02_策略/02_SmolVLA.md` |
| π₀ 系列 (Pi0/Pi0Fast/Pi05) | `02_策略/03_Pi0.md` ~ `05_Pi05.md` |
| GR00T N1.5 (NVIDIA) | `02_策略/06_GR00T_N1.md` |
| X-VLA | `02_策略/07_X_VLA.md` |
| 奖励模型 / SARM | `02_策略/09_奖励模型.md` ~ `10_SARM.md` |
| PEFT 微调 (LoRA) | `00_开始使用/10_PEFT微调.md` |
| 多 GPU 训练 | `00_开始使用/09_多GPU训练.md` |

### 处理器开发

| 主题 | 文档 |
|------|------|
| Processor 概念 | `05_机器人处理器/01_处理器介绍.md` |
| 调试管道 | `05_机器人处理器/02_调试处理器管道.md` |
| 自定义处理器 | `05_机器人处理器/03_实现自定义处理器.md` |
| 机器人/遥操作/环境处理器 | `05_机器人处理器/04_06_` |

### 仿真环境

| 环境 | 文档 |
|------|------|
| PushT / Aloha (Hub) | `04_模拟/01_Hub环境.md` |
| LeIsaac | `04_模拟/02_LeIsaac指南.md` |
| NVIDIA IsaacLab | `04_模拟/03_IsaacLab_Arena.md` |
| Libero | `04_模拟/04_Libero.md` |
| MetaWorld | `04_模拟/05_MetaWorld.md` |

### 推理部署

| 主题 | 文档 |
|------|------|
| 异步推理 | `03_推理/01_异步推理.md` |
| 实时分块 (RTC) | `03_推理/02_实时分块RTC.md` |

---

## 命令速查

### 版本检查

```bash
# 检查 LeRobot 版本
python -c "import lerobot; print(lerobot.__version__)"

# 检查已安装的 extras
pip list | grep lerobot
```

### 稳定版安装 (v0.5.1)

```bash
pip install lerobot==0.5.1
```

### 从源码安装（开发版）

```bash
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht,feetech]"
```

---

## 官方资源链接

| 资源 | 链接 |
|------|------|
| 官方文档 (stable v0.5.1) | https://huggingface.co/docs/lerobot/v0.5.1/en/index |
| 开发版文档 (main) | https://huggingface.co/docs/lerobot/main/en/index |
| GitHub 仓库 | https://github.com/huggingface/lerobot |
| Hugging Face Hub | https://huggingface.co/lerobot |
| Discord 社区 | https://discord.gg/s3KuuzsPFb |
| 模型列表 | https://huggingface.co/lerobot?sort=trending |
| 数据集列表 | https://huggingface.co/datasets?search=lerobot |

---

## 常见问题速查

| 问题 | 快速答案 |
|------|----------|
| 如何检查版本 | `python -c "import lerobot; print(lerobot.__version__)"` |
| 稳定版 vs 开发版 | 稳定版：`pip install lerobot`；开发版：从源码安装 |
| 需要 Python 版本 | Python >= 3.12 |
| 需要 PyTorch 版本 | PyTorch >= 2.10 |
| ffmpeg 何时需要 | Linux 仿真需要；macOS/Windows 自动使用 pyav fallback |
| 支持的 GPU | NVIDIA GPU (8GB+ VRAM) 或 Apple MPS |