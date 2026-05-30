# lerobot-assistant Skill

`lerobot-assistant` 是一个面向 Hugging Face LeRobot v0.5.1 的本地 Skill，用于辅助 AI 助手完成机器人学习环境检查、安装引导、SO-101/S101 配置、仿真到真机流程说明、知识库检索与常见故障排查。

本 Skill 不会自动修改系统环境。涉及安装依赖、`sudo`、硬件访问、Hugging Face Hub 上传等操作时，应先向用户确认。

## 能力范围

| 能力 | 说明 |
| --- | --- |
| 环境检测 | 检查 Python、conda/mamba、Git、LeRobot、PyTorch、GPU、ffmpeg、USB 串口和 Hugging Face CLI |
| 知识库检索 | 基于本地 `references/knowledge/` 中的 58 篇 LeRobot 相关知识文档回答问题 |
| SO-101/S101 引导 | 提供连接、校准、遥操作、数据采集与配置模板说明 |
| 策略与数据集 | 覆盖 ACT、SmolVLA、Pi0、LeRobotDataset、Hub、本地数据集处理等常见流程 |
| 仿真流程 | 提供 PushT、Aloha、LIBERO、Meta-World、LeIsaac/IsaacLab 等仿真优先验证指引 |
| 故障排查 | 针对安装、CUDA/PyTorch、ffmpeg、USB、摄像头、Hub 上传等问题给出诊断路径 |

## 安装方式

将 `install_skill.sh` 与 `lerobot_assistant_skill.tar.gz` 放在目标项目根目录，然后执行：

```bash
bash install_skill.sh
```

默认安装路径：

```text
.comate/skills/lerobot-assistant/
```

如果已经存在旧版本，安装脚本会先备份旧目录，再解压新版本。

## 触发方式

### 命令触发

```text
/lerobot-env
/lerobot-env check
/lerobot-env diagnose
```

### 自然语言触发

包含以下主题时可触发本 Skill：

```text
LeRobot、lerobot、SO-101、S101、SO101、teleoperate、calibrate、record、dataset、
ACT、SmolVLA、PushT、Aloha、LIBERO、Meta-World、PyTorch、CUDA、ffmpeg、
robot imitation learning、Hugging Face robotics
```

## 常用入口

环境检测：

```bash
bash .comate/skills/lerobot-assistant/scripts/env_check.sh
bash .comate/skills/lerobot-assistant/scripts/env_check.sh --json
```

生成 SO-101/S101 配置：

```bash
python3 .comate/skills/lerobot-assistant/scripts/render_so101_config.py \
  --robot-id demo_so101 \
  --robot-port /dev/ttyUSB0 \
  --teleop-port /dev/ttyUSB1 \
  --dataset-repo-id USER/so101_dataset
```

详细使用流程见：

```text
USAGE.md
scripts/install_guide.md
```

## 文件结构

```text
lerobot-assistant/
├── README.md
├── SKILL.md
├── USAGE.md
├── _meta.json
├── config.yaml
├── references/
│   ├── knowledge_index.md
│   └── knowledge/
├── scripts/
│   ├── env_check.sh
│   ├── install_guide.md
│   └── render_so101_config.py
└── templates/
    └── so101_config.yaml
```

## 来源说明

本 Skill 的知识内容主要依据：

- Hugging Face LeRobot 文档：https://huggingface.co/docs/lerobot/index
- LeRobot v0.5.1 文档页面
- Hugging Face LeRobot GitHub 仓库：https://github.com/huggingface/lerobot

本项目不是 Hugging Face 或 LeRobot 官方项目。
