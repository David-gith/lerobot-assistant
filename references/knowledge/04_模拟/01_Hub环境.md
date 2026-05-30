# Hub 环境

> **文档地址**：https://huggingface.co/docs/lerobot/v0.5.1/en/simulations/environments_from_hub

---

## 概述

LeRobot 提供来自 Hugging Face Hub 的预训练仿真环境，可以快速开始学习和评估策略，无需真实硬件。

**支持的仿真环境**：
- PushT：桌面物体推动任务
- Aloha：精细操作任务

---

## PushT 环境

### 环境特性

| 参数 | 值 |
|------|-----|
| 任务类型 | 2D 桌面操作 |
| 观测 | 图像 + 状态 |
| 动作 | 连续控制 |
| 难度 | 入门级 |

### 使用 PushT

```python
from lerobot.common.envs import make_env

env = make_env("pusht")
obs = env.reset()

for step in range(100):
    action = policy.select_action(obs)
    obs, reward, done, info = env.step(action)
```

### 命令行评估

```bash
lerobot-record \
    --env.type=pusht \
    --env.dataset=lerobot/pusht \
    --policy.type=act \
    --device=cuda
```

---

## Aloha 环境

### 环境特性

| 参数 | 值 |
|------|-----|
| 任务类型 | 精细操作 |
| 观测 | 多视角图像 + 双臂状态 |
| 动作 | 14 DOF 控制 |
| 难度 | 中级 |

### 使用 Aloha

```bash
# 安装 Aloha 依赖
pip install -e ".[aloha]"

# 运行仿真
python lerobot/examples/aloha_env.py
```

---

## 加载预训练数据集

```python
from lerobot import LeRobotDataset

# 加载 PushT 数据集
pusht = LeRobotDataset.from_repo_id("lerobot/pusht")
print(pusht)

# 加载 Aloha 数据集
aloha = LeRobotDataset.from_repo_id("lerobot/aloha_sim")
print(aloha)
```

---

## 训练和评估

### 在仿真中训练

```bash
lerobot-train \
    --env.type=pusht \
    --env.dataset=lerobot/pusht \
    --policy.type=act \
    --device=cuda
```

### 在仿真中评估

```bash
lerobot-record \
    --env.type=pusht \
    --env.dataset=lerobot/pusht \
    --policy.type=act \
    --policy.path=outputs/train/act/checkpoints/latest \
    --device=cuda
```

---

## 可视化

### 使用 Rerun

```bash
# 实时可视化
rerun outputs/train/act/eval

# 可视化数据集
rerun ~/.cache/huggingface/lerobot/{repo_id}
```

### 渲染 Episode

```python
from lerobot.common.datasets.utils import render_episode_video

render_episode_video(
    episode=dataset[0],
    output_path="pusht_episode.mp4",
    fps=30,
)
```

---

## 环境配置

### 自定义环境参数

```python
from lerobot.configs import EnvConfig

config = EnvConfig(
    env=PushTConfig(
        image_size=(256, 256),
        frame_skip=4,
    ),
)
```

---

## 相关文档

- [LeIsaac 指南](../04_模拟/02_LeIsaac指南.md)
- [IsaacLab Arena](../04_模拟/03_IsaacLab_Arena.md)

---

（来源：v0.5.1 Hub 环境文档）