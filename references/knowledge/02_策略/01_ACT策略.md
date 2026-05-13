# ACT 策略

> **策略类型**：模仿学习
> **全称**：Action Chunking with Transformers
> **适用场景**：真实机器人控制、精细操作任务
> **文档地址**：https://huggingface.co/docs/lerobot/v0.5.1/en/policies/act

---

## 简介

ACT (Action Chunking with Transformers) 是一种基于 Transformer 的模仿学习策略，通过动作分块机制实现平滑的机器人控制。

**核心特性**：
- Transformer 编码器-解码器架构
- 动作分块（chunking）实现低延迟控制
- 支持视觉输入（图像 + 状态）
- 端到端训练和部署

---

## 快速开始

### 训练 ACT

```bash
lerobot train \
    --repo-id ${HF_USER}/my_dataset \
    --policy.type=act \
    --device=cuda
```

### 评估 ACT

```bash
lerobot evaluate \
    --repo-id ${HF_USER}/my_dataset \
    --checkpoint=outputs/train/act/checkpoints/latest \
    --device=cuda
```

---

## 架构说明

### 输入

| 输入 | 形状 | 说明 |
|------|------|------|
| 图像观察 | (B, C, H, W) | 相机图像 |
| 状态向量 | (B, D) | 关节位置等 |
| 语言指令（可选） | (B, L) | 分词后的指令 |

### 输出

| 输出 | 形状 | 说明 |
|------|------|------|
| 动作序列 | (B, T, A) | T 个时间步的 A 维动作 |

### 模型配置

```python
from lerobot.configs import PolicyConfig

config = PolicyConfig(
    policy=ActConfig(
        model=ActModelConfig(
            vision_encoder="resnet18",
            hidden_dim=512,
            num_layers=6,
            num_heads=8,
        ),
        chunk_size=8,      # 动作分块大小
        temporal_agg="act",  # ACT 时序聚合
    ),
)
```

---

## 训练参数

### 常用参数

```bash
lerobot train \
    --repo-id ${HF_USER}/my_dataset \
    --policy.type=act \
    --policy.lr=1e-4 \           # 学习率
    --policy.batch_size=8 \     # 批大小
    --policy.num_workers=4 \    # 数据加载线程数
    --policy.total_epochs=100 \  # 训练轮数
    --policy.chunk_size=8 \      # 动作分块大小
    --device=cuda
```

### 参数说明

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--policy.lr` | 1e-4 | 学习率 |
| `--policy.batch_size` | 8 | 批大小，GPU 内存不足时减小 |
| `--policy.num_workers` | 4 | 数据加载线程 |
| `--policy.total_epochs` | 100 | 训练轮数 |
| `--policy.chunk_size` | 8 | 动作分块，较大值=更平滑但延迟更高 |
| `--policy.warmup_epochs` | 10 | 预热轮数 |

---

## 微调预训练模型

### 从 Hub 下载预训练模型

```bash
# ACT 预训练模型列表
# lerobot/act_koch_real
# lerobot/act_so100_real
```

### 微调

```bash
lerobot train \
    --repo-id ${HF_USER}/my_dataset \
    --policy.type=act \
    --checkpoint=lerobot/act_koch_real \
    --device=cuda
```

---

## Python API

### 训练

```python
from lerobot.scripts.train import train

train(
    repo_id="your_user/my_dataset",
    policy_type="act",
    device="cuda",
)
```

### 评估

```python
from lerobot.scripts.evaluate import evaluate

evaluate(
    repo_id="your_user/my_dataset",
    checkpoint="outputs/train/act/checkpoints/latest",
    device="cuda",
)
```

### 推理

```python
from lerobot import LeRobotDataset
from lerobot.policies.act import ActPolicy

# 加载策略
policy = ActPolicy.from_pretrained("lerobot/act_koch_real")
policy.eval()

# 加载数据集获取观察
dataset = LeRobotDataset.from_repo_id("lerobot/pusht")
sample = dataset[0][0]

# 推理
with torch.no_grad():
    action = policy.select_action(sample)
print(f"Action: {action.shape}")  # (T, A)
```

---

## 动作分块机制

ACT 的核心思想是将多个时间步的动作作为一个块来预测：

```
时间:  t=0    t=1    t=2    t=3    t=4    t=5
观察: [o0]   [o1]   [o2]   [o3]   [o4]   [o5]
预测: [a0..a7]           [a8..a15]
                              ↑
                        执行 a0, 等待
                        执行 a1, 等待
                        ...
```

**优势**：
- 降低控制频率要求
- 动作更平滑
- 减少计算延迟

---

## 与其他策略对比

| 策略 | 类型 | 延迟 | 适用场景 |
|------|------|------|----------|
| ACT | 模仿学习 | 中 | 精细操作、抓取 |
| Diffusion | 模仿学习 | 高 | 复杂轨迹 |
| TDMPC | 强化学习 | 中 | 长期任务 |

---

## 故障排查

### 问题：训练 loss 不下降

**检查**：
1. 数据集是否正确加载
2. 动作维度是否匹配
3. 学习率是否过大/过小

### 问题：推理动作抖动

**解决**：
1. 增加 chunk_size
2. 检查动作归一化
3. 减小控制频率

### 问题：GPU 内存不足

**解决**：
1. 减小 batch_size
2. 减小图像分辨率
3. 使用更小的 vision encoder (resnet10)

---

## 相关文档

- [机器人的模仿学习](../00_开始使用/03_机器人的模仿学习.md)
- [SmolVLA 策略](02_SmolVLA.md)
- [π₀ 策略](03_Pi0.md)

---

（来源：v0.5.1 ACT 策略文档）