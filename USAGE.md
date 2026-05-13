# LeRobot 助手详细使用手册

本手册提供 LeRobot 环境配置、硬件连接、数据集处理和训练部署的详细指南。

---

## 目录

1. [安装流程](#安装流程)
2. [硬件连接](#硬件连接)
3. [数据集处理](#数据集处理)
4. [策略训练](#策略训练)
5. [仿真环境](#仿真环境)
6. [故障诊断](#故障诊断)
7. [命令参考](#命令参考)

---

## 1. 安装流程

### 1.1 环境检测

首次使用前，建议运行环境检测：

```bash
bash .comate/skills/lerobot-assistant/scripts/env_check.sh
```

或输出 JSON 格式结果：

```bash
bash .comate/skills/lerobot-assistant/scripts/env_check.sh --json
```

### 1.2 安装 miniforge（推荐）

```bash
# 下载并安装 miniforge
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

# 按照提示完成安装后，激活 base 环境
source ~/miniforge3/bin/activate
```

### 1.3 创建 Python 环境

```bash
# 创建 Python 3.12 环境
conda create -n lerobot python=3.12 -y

# 激活环境
conda activate lerobot
```

### 1.4 安装 LeRobot

#### 方式 A：从源码安装（推荐开发使用）

```bash
# 克隆仓库
git clone https://github.com/huggingface/lerobot.git
cd lerobot

# 安装基础包
pip install -e .

# 安装可选依赖（仿真 + 视频支持）
pip install -e ".[aloha,pusht]"
```

#### 方式 B：从 PyPI 安装（稳定版 v0.5.1）

```bash
pip install lerobot==0.5.1
```

### 1.5 安装 ffmpeg（Linux 必须）

```bash
# 使用 conda 安装（推荐）
conda install -c conda-forge ffmpeg

# 或使用系统包管理器
# Ubuntu/Debian:
sudo apt install ffmpeg
# macOS:
brew install ffmpeg
```

**注意**：如果安装 ffmpeg 后 OpenCV 出现问题，尝试：

```bash
pip uninstall opencv-python
conda install -c conda-forge "opencv>=4.10.0"
```

### 1.6 安装硬件 SDK（按需）

```bash
# SO-101 / SO-102 / Moss 机器人
pip install -e ".[feetech]"

# Koch v1.1 机械臂
pip install -e ".[dynamixel]"

# Aloha 仿真/硬件
pip install -e ".[aloha]"
```

### 1.7 验证安装

```bash
# 检查版本
python -c "import lerobot; print(lerobot.__version__)"

# 检查 CLI 命令
lerobot --help

# 检查可用的子命令
lerobot --help
# 输出应包含: teleoperate, record, train, evaluate
```

---

## 2. 硬件连接

### 2.1 串口权限设置（Linux）

```bash
# 检查当前用户是否在 dialout 组
groups | grep dialout

# 如果不在，添加到 dialout 组
sudo usermod -a -G dialout $USER

# 重新登录或重启使生效
# 或临时生效：
newgrp dialout
```

### 2.2 查找 USB 端口

```bash
# Linux
ls -l /dev/ttyUSB*
ls -l /dev/ttyACM*

# macOS
ls -l /dev/tty.usbmodem*
```

### 2.3 SO-101 连接流程

```bash
# 1. 安装 SDK
pip install -e ".[feetech]"

# 2. 连接 USB 线，查找端口
ls /dev/ttyUSB*   # Linux
ls /dev/tty.usbmodem*  # macOS

# 3. 校准 Follower（执行器）
lerobot-calibrate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_awesome_robot

# 4. 校准 Leader（遥操作器）
lerobot-calibrate \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_awesome_leader

# 5. 遥操作测试
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_awesome_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_awesome_leader \
    --display_data=true
```

### 2.4 Koch 机械臂连接流程

```bash
# 1. 安装 SDK
pip install -e ".[dynamixel]"

# 2. 设置电压（重要！）
# Leader (小臂): 5V
# Follower (大臂): 12V

# 3. 查找端口并校准
lerobot-calibrate --robot.type=koch_follower --robot.port=/dev/ttyUSB0 --robot.id=koch
lerobot-calibrate --teleop.type=koch_leader --teleop.port=/dev/ttyUSB1 --teleop.id=koch_leader

# 4. 遥操作
lerobot-teleoperate \
    --robot.type=koch_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=koch \
    --teleop.type=koch_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=koch_leader
```

### 2.5 添加摄像头

```bash
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_robot \
    --robot.cameras="{front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
    --display_data=true
```

---

## 3. 数据集处理

### 3.1 录制数据集

```bash
# 基本录制
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_leader \
    --fps 30 \
    --repo-id ${USER}/my_dataset \
    --episode-time-s 60 \
    --num-episodes 50

# 不上传 Hub（本地保存）
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_leader \
    --fps 30 \
    --repo-id ${USER}/my_dataset \
    --dataset.push_to_hub=false

# 恢复中断的录制
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyUSB0 \
    --robot.id=my_robot \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyUSB1 \
    --teleop.id=my_leader \
    --fps 30 \
    --repo-id ${USER}/my_dataset \
    --control.resume=true
```

### 3.2 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--fps` | 帧率 | 30 |
| `--warmup-time-s` | 预热时间（秒） | 5 |
| `--episode-time-s` | 每个 episode 时长 | 60 |
| `--reset-time-s` | 重置时间 | 30 |
| `--num-episodes` | 录制的 episode 数量 | 50 |
| `--dataset.push_to_hub` | 是否上传到 Hub | true |
| `--dataset.normalize_actions` | 是否归一化动作 | false |

### 3.3 上传到 Hugging Face Hub

```bash
# 确保已登录
huggingface-cli login

# 手动上传本地数据集
python -c "
from lerobot import LeRobotDataset
ds = LeRobotDataset.from_repo_id('${USER}/my_dataset')
ds.push_to_hub('${USER}/my_dataset')
"
```

### 3.4 查看和下载已有数据集

```bash
# 列出 LeRobot 相关数据集
# 访问 https://huggingface.co/datasets?search=lerobot

# 加载数据集
python -c "
from lerobot import LeRobotDataset
ds = LeRobotDataset.from_repo_id('lerobot/pusht')
print(ds)
"
```

---

## 4. 策略训练

### 4.1 训练 ACT 策略

```bash
# 使用本地数据集训练
lerobot train \
    --repo-id ${USER}/my_dataset \
    --policy.type=act \
    --device=cuda  # Linux GPU

# macOS 使用 MPS
lerobot train \
    --repo-id ${USER}/my_dataset \
    --policy.type=act \
    --device=mps

# 指定训练参数
lerobot train \
    --repo-id ${USER}/my_dataset \
    --policy.type=act \
    --policy.lr=1e-4 \
    --policy.batch_size=8 \
    --training.num_workers=4 \
    --device=cuda
```

### 4.2 训练 Diffusion 策略

```bash
lerobot train \
    --repo-id ${USER}/my_dataset \
    --policy.type=diffusion \
    --device=cuda
```

### 4.3 使用预训练模型

```bash
# 下载并评估预训练模型
lerobot evaluate \
    --repo-id lerobot/smolvla_vlabench \
    --device=cuda

# 在自己的数据集上微调
lerobot train \
    --repo-id ${USER}/my_dataset \
    --policy.type=act \
    --checkpoint=lerobot/act_koch_real \
    --device=cuda
```

### 4.4 评估策略

```bash
# 评估本地训练的模型
lerobot evaluate \
    --repo-id ${USER}/my_dataset \
    --checkpoint=outputs/train/act/checkpoints/latest \
    --device=cuda

# 可视化评估结果
rerun outputs/train/act/eval
```

---

## 5. 仿真环境

### 5.1 Aloha 仿真

```bash
# 安装仿真环境
pip install -e ".[aloha]"

# 运行仿真环境
python lerobot/examples/aloha_env.py
```

### 5.2 PushT 仿真

```bash
# 安装仿真环境
pip install -e ".[pusht]"

# 运行仿真环境
python lerobot/examples/pusht_env.py
```

### 5.3 切换仿真与真机

```bash
# 真机：使用 --robot.type 指定硬件类型
lerobot-teleoperate --robot.type=so101_follower ...

# 仿真：使用仿真环境配置
python lerobot/examples/pusht_env.py --use_camera=False
```

---

## 6. 故障诊断

### 6.1 Python 环境问题

| 问题 | 解决方案 |
|------|----------|
| Python 版本 < 3.12 | 创建新环境：`conda create -n lerobot python=3.12` |
| 导入 lerobot 失败 | 检查 pip 安装路径：`pip show lerobot` |
| 包冲突 | 创建新环境或使用 `pip install --force-reinstall` |

### 6.2 PyTorch/CUDA 问题

| 问题 | 解决方案 |
|------|----------|
| CUDA out of memory | 减小 batch_size 或使用更小的模型 |
| PyTorch 版本不兼容 | 升级 PyTorch：`pip install torch>=2.10` |
| GPU 不可用 | 检查 nvidia-smi；macOS 使用 MPS |

### 6.3 USB 端口问题

| 问题 | 解决方案 |
|------|----------|
| Permission denied | 添加用户到 dialout 组：`sudo usermod -a -G dialout $USER` |
| 找不到端口 | 检查 USB 连接；尝试不同端口；查看 dmesg |
| 端口被占用 | `lsof /dev/ttyUSB0` 查找占用进程 |

### 6.4 视频录制问题

| 问题 | 解决方案 |
|------|----------|
| ffmpeg 未安装 | `conda install -c conda-forge ffmpeg` |
| 视频编码失败 | 检查 ffmpeg 版本和路径 |
| 视频播放无画面 | 可能是解码问题，检查 PyAV/TorchCodec |

### 6.5 Hugging Face Hub 问题

| 问题 | 解决方案 |
|------|----------|
| 未登录 | `huggingface-cli login` |
| Token 无效 | 生成新 Token：https://huggingface.co/settings/tokens |
| 上传失败 | 检查磁盘空间和网络连接 |

---

## 7. 命令参考

### 7.1 CLI 命令概览

```bash
lerobot --help
# 可用命令:
#   teleoperate  - 遥操作机器人
#   record       - 录制数据集
#   train        - 训练策略
#   evaluate     - 评估策略
```

### 7.2 lerobot-teleoperate

```bash
lerobot-teleoperate --help

# 必需参数:
#   --robot.type          机器人类型 (so101_follower, koch_follower, ...)
#   --robot.port          串口端口
#   --robot.id            机器人 ID
#   --teleop.type         遥操作设备类型 (so101_leader, koch_leader, ...)
#   --teleop.port         遥操作设备端口
#   --teleop.id           遥操作设备 ID

# 可选参数:
#   --robot.cameras       相机配置 JSON
#   --display_data        显示数据
```

### 7.3 lerobot-record

```bash
lerobot-record --help

# 必需参数: (同 teleoperate)

# 可选参数:
#   --fps                 帧率
#   --warmup-time-s       预热时间
#   --episode-time-s      Episode 时长
#   --reset-time-s        重置时间
#   --num-episodes        Episode 数量
#   --repo-id             数据集 ID (格式: USER/dataset_name)
#   --dataset.push_to_hub 是否上传到 Hub
```

### 7.4 lerobot-train

```bash
lerobot-train --help

# 必需参数:
#   --repo-id             数据集 ID

# 可选参数:
#   --policy.type         策略类型 (act, diffusion, ...)
#   --device             设备 (cuda, mps, cpu)
#   --checkpoint          预训练模型检查点
```

### 7.5 lerobot-calibrate

```bash
lerobot-calibrate --help

# 示例:
lerobot-calibrate --robot.type=so101_follower --robot.port=/dev/ttyUSB0 --robot.id=my_robot
```

---

## 附录：常见错误信息

### 错误：ModuleNotFoundError: No module named 'feetech_servo_sdk'

**原因**：未安装 Feetech SDK

**解决**：
```bash
pip install -e ".[feetech]"
```

### 错误：CUDA error: no kernel image is available

**原因**：GPU 驱动太旧或 PyTorch 版本不匹配

**解决**：
```bash
nvidia-smi  # 检查驱动版本
pip install torch --upgrade  # 升级 PyTorch
```

### 错误：Permission denied: /dev/ttyUSB0

**原因**：当前用户没有串口访问权限

**解决**：
```bash
sudo usermod -a -G dialout $USER
# 重新登录使生效
```

### 错误：ffmpeg: command not found

**原因**：ffmpeg 未安装

**解决**：
```bash
# Linux
sudo apt install ffmpeg
# 或
conda install -c conda-forge ffmpeg

# macOS
brew install ffmpeg
```

---

## 参考链接

- 官方文档：https://huggingface.co/docs/lerobot/v0.5.1/en/index
- GitHub：https://github.com/huggingface/lerobot
- Discord：https://discord.gg/s3KuuzsPFb
- HF Hub：https://huggingface.co/lerobot