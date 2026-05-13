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

### 📦 Skill 安装方法

#### 前置要求
- Comate 环境（支持 skill 功能的 Comate 版本）
- 访问 skill 存储库或本地 skill 文件的权限

#### 安装方式

**方式 1：通过 Comate 界面安装**
1. 打开 Comate 技能市场或技能管理界面
2. 搜索 "lerobot-assistant" 或 "LeRobot 机器人学习助手"
3. 点击安装按钮，等待技能加载完成
4. 安装完成后，技能将自动启用

**方式 2：本地技能文件安装**
如果您有本地的技能文件：
1. 将 `lerobot-assistant` 文件夹放置在 Comate 的技能目录中
2. 通常在：`~/.comate/skills/` 或 Comate 安装目录的 `skills/` 文件夹
3. 重启 Comate 或重新加载技能列表
4. 在技能管理界面启用该技能

**方式 3：开发者模式安装**
如果您是开发者：
```bash
# 克隆技能仓库（如果适用）
git clone <skill-repository-url>

# 将技能文件夹复制到 Comate 技能目录
cp -r lerobot-assistant ~/.comate/skills/

# 重启 Comate 应用
```

#### 验证安装
安装完成后，您可以：
1. 在 Comate 技能列表中看到 "LeRobot 机器人学习助手"
2. 技能状态显示为已启用
3. 在对话中提到相关关键词时，技能会自动触发

### ⚙️ LeRobot 环境要求

**系统要求**
- **Python**: ≥ 3.12（推荐 3.12）
- **PyTorch**: ≥ 2.10
- **操作系统**: 推荐 Linux/macOS，Windows 建议使用 WSL2

**快速安装 LeRobot（稳定版）**
```bash
pip install lerobot==0.5.1
```

**开发版安装（从源码）**
```bash
conda create -n lerobot python=3.12 -y
conda activate lerobot
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht,feetech]"
```

## 🎯 如何使用这个 Skill

### 激活方式
当您在对话中提到以下关键词时，将自动触发此 skill：
- **LeRobot, lerobot, huggingface, 机器人**
- **teleoperate, record, calibrate, 训练**
- **policy, 数据集, Hub, 安装**
- **ffmpeg, conda, SO101, Koch, Aloha, Unitree**

### 使用模式

#### 模式 1：环境检测与安装引导
```bash
# 触发完整环境设置流程
/lerobot-env

# 仅检查系统环境
/lerobot-env check

# 直接安装缺失项（跳过检测）
/lerobot-env install

# 故障诊断模式
/lerobot-env diagnose
```

#### 模式 2：交互式问答
直接提问与 LeRobot 相关的问题，如：
- "如何安装 LeRobot？"
- "SO-101 机器人怎么连接？"
- "数据集录制失败怎么办？"
- "PyTorch GPU 报错如何解决？"

#### 模式 3：特定功能调用
```bash
# 环境状态检查
bash scripts/env_check.sh

# 详细结构化的环境信息
bash scripts/env_check.sh --json

# 机器人硬件快速测试
lerobot-calibrate --robot.type=so101_follower --robot.port=/dev/ttyUSB0
```

### 交互流程说明

#### 1. 智能环境检测
- ✅ 自动检测 Python 版本（需 ≥ 3.12）
- ✅ 检查 conda/mamba 环境管理器
- ✅ 验证 LeRobot 安装状态
- ✅ 检测 GPU/CUDA 支持情况
- ✅ 检查 ffmpeg 等关键依赖

#### 2. 分步安装引导
```bash
# 示例安装流程（由助手指导执行）
conda create -n lerobot python=3.12 -y
conda activate lerobot
git clone https://github.com/huggingface/lerobot.git
cd lerobot
pip install -e ".[aloha,pusht,feetech]"
```

#### 3. 知识库检索
助手会根据您的问题类型自动搜索相应知识库目录：
- **安装问题** → `00_开始使用/`，`09_FAQ故障排查/`
- **硬件连接** → `06_机器人硬件/`，`07_遥操作员/`
- **数据集** → `01_数据集/`，`10_资源与工具/`
- **训练策略** → `02_策略/`，`04_训练部署/`
- **仿真环境** → `05_模拟/`，`09_PyTorch加速器/`

### 使用示例

#### 示例 1：快速环境配置
```
用户：我需要设置 LeRobot 开发环境
助手：检测到您需要配置 LeRobot 环境，让我先检查系统状态...
     运行环境检测脚本...
     检测结果：Python 版本 ✓，conda ✓，LeRobot 未安装
     建议安装开发版，确认开始安装流程？
```

#### 示例 2：硬件连接问题
```
用户：SO-101 机器人连接失败，找不到 USB 端口
助手：检测到机器人硬件连接问题，正在搜索解决方案...
     1. 检查 USB 端口权限：ls -la /dev/ttyUSB*
     2. 添加用户到 dialout 组：sudo usermod -a -G dialout $USER
     3. 重新插拔 USB 设备并重启服务
```

#### 示例 3：训练故障排查
```
用户：训练 ACT 策略时报 CUDA 内存不足
助手：检测到 GPU 内存问题，推荐优化方案：
     1. 减小 batch_size：--training.batch_size=32
     2. 启用梯度累积：--training.gradient_accumulation_steps=2
     3. 使用混合精度训练：--training.mixed_precision=bf16
```

### 高级功能

#### 自动化检测
使用 `--json` 参数获取结构化数据：
```bash
bash scripts/env_check.sh --json
# 输出示例：{"python_version": "3.12.1", "lerobot_installed": false, ...}
```

#### 快速命令卡片
skill 内置常用命令卡片，快速获取：
- 硬件连接步骤
- 数据集录制命令
- 训练参数配置
- 故障修复方案

### 故障模式

#### 诊断模式
当遇到复杂问题时，使用诊断模式：
```bash
/lerobot-env diagnose
```

助手将：
1. 运行完整环境检测
2. 分析错误日志
3. 在知识库中匹配类似问题
4. 提供分步修复方案

#### 安全限制
- 所有 `sudo` 操作需用户确认
- 安装步骤具备幂等性（已安装的自动跳过）
- 重大系统修改前提供备份建议

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