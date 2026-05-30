# SmolVLA 策略

> **策略类型**：视觉语言动作模型 (Vision-Language-Action Model)
> **适用场景**：通用机器人操作、语言指令控制
> **文档地址**：https://huggingface.co/docs/lerobot/v0.5.1/en/policies/smolvla

---

## 简介

SmolVLA (Small Vision-Language-Action Model) 是一种轻量级的视觉语言动作模型，能够根据语言指令控制机器人。

**核心特性**：
- 视觉-语言-动作统一建模
- 支持自然语言指令
- 轻量级设计，适合边缘部署
- 开源模型，可微调

---

## 支持的模型

| 模型 | 参数量 | 说明 |
|------|--------|------|
| `lerobot/smolvla_vlabench` | ~300M | VLA-Bench 基准测试 |
| `lerobot/smolvla_libero` | ~300M | Libero 基准测试 |
| `lerobot/smolvla_metaworld` | ~300M | MetaWorld 基准测试 |

---

## 快速开始

### 评估预训练模型

```bash
lerobot-record \
    --dataset.repo_id lerobot/smolvla_vlabench \
    --device=cuda
```

### 使用语言指令

```bash
lerobot-record \
    --dataset.repo_id lerobot/smolvla_vlabench \
    --task="Pick up the red block and place it in the blue box" \
    --device=cuda
```

---

## 训练 SmolVLA

### 基本训练

```bash
lerobot-train \
    --dataset.repo_id ${HF_USER}/my_dataset \
    --policy.type=smolvla \
    --device=cuda
```

### 自定义配置

```bash
lerobot-train \
    --dataset.repo_id ${HF_USER}/my_dataset \
    --policy.type=smolvla \
    --policy.vision_encoder=vit_b \
    --policy.lr=1e-4 \
    --policy.batch_size=4 \
    --device=cuda
```

---

## 架构说明

### 输入

| 输入 | 类型 | 说明 |
|------|------|------|
| 图像 | Image | 相机观察 |
| 状态 | Vector | 关节位置 |
| 语言指令 | Text | 自然语言任务描述 |

### 处理流程

```
图像 → Vision Encoder → Visual Features
语言 → Language Encoder → Language Features
状态 → MLP → State Features

[Visual + Language + State] → Transformer → 动作输出
```

---

## 推理

### Python API

```python
from lerobot.policies.smolvla import SmolVLAPolicy

# 加载模型
policy = SmolVLAPolicy.from_pretrained("lerobot/smolvla_vlabench")
policy.eval()

# 准备输入
sample = {
    "observation.images.front": image_tensor,      # (3, H, W)
    "observation.state": state_tensor,              # (D,)
    "task": "pick up the red block",               # str
}

# 推理
with torch.no_grad():
    action = policy.select_action(sample)
```

---

## 微调

### 在自定义数据集上微调

```bash
lerobot-train \
    --dataset.repo_id ${HF_USER}/my_dataset \
    --policy.type=smolvla \
    --policy.path=lerobot/smolvla_vlabench \
    --policy.lr=1e-5 \         # 较低学习率
    --policy.total_epochs=50 \
    --device=cuda
```

---

## 与其他 VLA 模型对比

| 模型 | 参数量 | 语言支持 | 部署难度 |
|------|--------|----------|----------|
| SmolVLA | ~300M | 是 | 低 |
| π₀ | ~7B | 是 | 高 |
| GR00T N1.5 | ~15B | 是 | 高 |

---

## 故障排查

### 问题：语言指令不生效

**检查**：
1. 数据集是否包含 task 字段
2. 语言描述格式是否正确

### 问题：推理速度慢

**解决**：
1. 使用量化模型
2. 减小图像分辨率
3. 使用批处理

---

## 相关文档

- [ACT 策略](01_ACT策略.md)
- [π₀ 策略](03_Pi0.md)
- [GR00T N1.5 策略](06_GR00T_N1.md)

---

（来源：v0.5.1 SmolVLA 文档）