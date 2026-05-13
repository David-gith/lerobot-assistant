# LeRobot 机器人学习助手

LeRobot 机器人学习助手是一个专为 LeRobot 框架设计的 AI 助手技能，提供完整的环境配置、安装引导、故障排查和知识库检索功能。

## 功能特性

### 🚀 核心能力
- **智能环境检测** - 自动检测系统环境、Python 版本、依赖缺失情况
- **交互式安装引导** - 分步指导完成 LeRobot 完整安装流程
- **知识库检索** - 基于结构化知识库提供精准问题解答
- **机器人硬件支持** - 支持多种机器人硬件（SO-101、Koch、Aloha、Unitree等）
- **故障诊断** - 提供详细的错误排查和修复指导

### 🤖 支持场景
1. **LeRobot 安装与环境配置**（conda、pip、依赖安装、ffmpeg）
2. **机器人硬件连接与校准**（SO-101、Koch、Aloha、Unitree等）
3. **数据集录制与可视化**（teleoperation、record、HF Hub）
4. **策略训练与部署**（imitation learning、reinforcement learning）
5. **仿真环境配置**（Aloha、PushT）
6. **常见问题排查与故障诊断**

## 快速开始

### 环境要求
- **Python**: ≥ 3.12（推荐 3.12）
- **PyTorch**: ≥ 2.10
- **系统**: 推荐 Linux/macOS，Windows 建议使用 WSL2

### 快速安装（稳定版）
```bash
pip install lerobot==0.5.1
```

### 开发版安装（从源码）
```bash
conda create -n lerobot python=3.12 -y
conda activate lerobot
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht,feetech]"
```

## 使用方法

### 1. 环境检测
运行环境检测脚本查看系统状态：
```bash
bash scripts/env_check.sh
```

### 2. 交互式安装
助手提供分步安装引导：
- 检测当前环境状态
- 确认缺失依赖项
- 执行安装步骤
- 验证安装结果

### 3. 知识库查询
助手内置丰富知识库，覆盖以下主题：
- 安装指南和快速入门
- 机器人硬件连接和校准
- 数据集录制和处理
- 策略训练和模型部署
- 仿真环境配置
- 故障排查和常见问题

### 4. 硬件连接支持
#### SO-101 机器人连接示例
```bash
# 安装 Feetech SDK
pip install -e ".[feetech]"

# 校准机器人
lerobot-calibrate --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot

# 遥操作测试
lerobot-teleoperate --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot \
    --teleop.type=so101_leader --teleop.port=/dev/ttyUSB1 --teleop.id=my_leader
```

## 核心工作流程

### 工作流 1：快速上手
```bash
pip install lerobot==0.5.1
python -c "import lerobot; print(lerobot.__version__)"
lerobot evaluate --repo-id lerobot/pusht
```

### 工作流 2：数据集录制与训练
```bash
# 录制数据集
lerobot-record --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot \
    --teleop.type=so101_leader --teleop.port=/dev/ttyUSB1 --teleop.id=my_leader \
    --fps 30 --repo-id YOUR_USER/my_dataset --push-to-hub=true

# 训练策略
lerobot train --repo-id YOUR_USER/my_dataset --policy.type=act --device=cuda

# 评估策略
lerobot evaluate --repo-id YOUR_USER/my_dataset --checkpoint=checkpoint_latest
```

### 工作流 3：使用预训练模型
```bash
pip install lerobot

# 评估预训练模型
lerobot evaluate --repo-id lerobot/smolvla_vlabench --device=cuda

# 微调训练
lerobot train --repo-id YOUR_USER/my_dataset --policy.type=act --policy.use_lora=true
```

## 目录结构

```
lerobot-assistant/
├── _meta.json               # 元数据配置
├── config.yaml              # 版本要求和 URL 配置
├── SKILL.md                 # 技能定义文件（完整功能说明）
├── USAGE.md                 # 详细使用手册
├── README.md               # 本文档
├── scripts/
│   └── env_check.sh         # 环境检测脚本（支持 --json 输出）
└── references/
    ├── knowledge_index.md   # 知识库索引
    └── knowledge/           # 完整的知识库文档（11个子目录）
        ├── 00_开始使用/      # 安装、快速入门、模仿学习、RL、PEFT
        ├── 01_数据集/       # LeRobotDataset、移植、工具
        ├── 02_策略/         # ACT、SmolVLA、π₀系列等
        ├── 03_推理/         # 异步推理、RTC
        ├── 04_模拟/         # Hub环境、各种仿真器
        ├── 05_机器人处理器/  # 处理器概念和调试
        ├── 06_机器人硬件/    # 8种机器人硬件支持
        ├── 07_遥操作员/      # 遥操作指南
        ├── 08_摄像头/        # 摄像头配置
        ├── 09_PyTorch加速器/ # CUDA、MPS设备
        ├── 10_资源与工具/     # Notebooks和Hub资源
        └── 11_关于/          # 贡献指南
```

## 支持的关键词

触发助手的关键词包括：
- **LeRobot, lerobot, huggingface, 机器人**
- **teleoperate, record, calibrate, 训练**
- **policy, 数据集, Hub, 安装**
- **ffmpeg, conda, SO101, Koch, Aloha, Unitree**

## 重要说明

- **安全性**：所有涉及 `sudo` 的操作都会事先征求用户确认
- **幂等性**：安装步骤会自动检测已完成的步骤并跳过
- **系统支持**：主要支持 Linux/macOS，Windows 建议使用 WSL2
- **GPU 推荐**：训练建议使用 NVIDIA GPU（8GB+ VRAM）

## 故障排查

遇到问题时：
1. 运行 `/lerobot-env diagnose` 进行基础诊断
2. 检查系统环境：`bash scripts/env_check.sh`
3. 查看知识库 `references/knowledge/09_FAQ故障排查/` 目录
4. 使用 `--json` 参数获取结构化诊断信息

## 联系方式

如有问题或需要进一步的帮助，请参考：
- [LeRobot 官方仓库](https://github.com/huggingface/lerobot)
- [Hugging Face LeRobot 页面](https://huggingface.co/lerobot)

---

**版本**: 基于 LeRobot v0.5.1+  
**最后更新**: 2026-05-13