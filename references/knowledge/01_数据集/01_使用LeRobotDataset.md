# 使用 LeRobotDataset

> **文档地址**：https://huggingface.co/docs/lerobot/v0.5.1/en/datasets_overview

---

## 什么是 LeRobotDataset

LeRobotDataset 是一种标准化的数据集格式，基于 Parquet 存储观察数据，MP4 存储视频，支持 Hugging Face Hub 托管。

**核心特性**：
- 高效存储和流式传输大规模机器人数据集
- 支持视频和图像观察
- 与 Hugging Face 生态系统无缝集成
- 提供可视化和加载工具

---

## 加载数据集

### 从 Hugging Face Hub 加载

```python
from lerobot import LeRobotDataset

# 加载预训练数据集
dataset = LeRobotDataset.from_repo_id("lerobot/pusht")
print(dataset)

# 查看数据集信息
print(f"Episodes: {len(dataset)}")
print(f"Episode length: {dataset.num_samples}")
print(f"Features: {dataset.features}")
```

### 使用数据集配置

```python
from lerobot.configs import Task

# 加载任务配置
task = Task.from_repo_id("lerobot/pusht")
dataset = LeRobotDataset.from_config(task.dataset)
```

### 加载本地数据集

```python
from lerobot import LeRobotDataset

dataset = LeRobotDataset(
    repo_id="your_user/my_dataset",
    base_path="~/.cache/huggingface/lerobot/",
)
```

---

## 数据集结构

### 基本属性

```python
# 仓库 ID
print(dataset.repo_id)

# Episode 数量
print(len(dataset))

# 总样本数
print(dataset.num_samples)

# 特征信息
print(dataset.features)
# 输出示例:
# {
#     'observation.images.front': Image(mode='RGB'),
#     'observation.state': Sequence(feature=Value(dtype='float32', id=null), length=-1, id=null, is_sequence=true),
#     'action': Sequence(feature=Value(dtype='float32', id=null), length=-1, id=null, is_sequence=true),
# }
```

### Episode 迭代

```python
# 遍历 episodes
for episode in dataset:
    print(f"Episode length: {len(episode)}")
    # episode 是 Episode 对象

# 获取特定 episode
episode = dataset[0]
```

### 样本迭代

```python
# 遍历单个 episode 的样本
for i, sample in enumerate(dataset[0]):
    state = sample["observation.state"]
    action = sample["action"]
    print(f"Sample {i}: state shape={state.shape}")
```

---

## 数据集格式

### 观察 (Observation)

| 字段 | 类型 | 说明 |
|------|------|------|
| `observation.images.{camera}` | Image | 相机图像 |
| `observation.state` | float32[] | 机器人状态（关节位置/角度） |
| `observation.effort` | float32[] | 力/力矩 |
| `observation.velocity` | float32[] | 速度 |

### 动作 (Action)

| 字段 | 类型 | 说明 |
|------|------|------|
| `action` | float32[] | 目标动作 |
| `action.delta_state` | float32[] | 增量动作 |
| `action.velocity` | float32[] | 速度动作 |

### 元数据

| 字段 | 类型 | 说明 |
|------|------|------|
| `frame_index` | int | 帧索引 |
| `timestamp` | float | 时间戳 |
| `episode_index` | int | Episode 索引 |

---

## 数据集统计

```python
from lerobot.common.datasets.compute_stats import compute_stats

# 计算数据集统计信息
stats = compute_stats(dataset)

# 统计信息包含：
# - mean/std (归一化参数)
# - min/max (范围)
# - video info
print(stats)
```

---

## 可视化

### 可视化 Episode

```python
# 使用 IPython/Jupyter
dataset[0].visualize()
```

### 导出为视频

```python
from lerobot.common.datasets.utils import render_episode_video

# 渲染 episode 为视频
render_episode_video(
    episode=dataset[0],
    output_path="episode_0.mp4",
    fps=30,
)
```

### 使用 Rerun 可视化

```python
import rerun as rr

rr.init("dataset_viewer")

for sample in dataset[0]:
    rr.set_time_sequence("frame", sample["frame_index"])

    # 显示图像
    if "observation.images.front" in sample:
        rr.log_image("camera/front", sample["observation.images.front"])

    # 显示状态
    if "observation.state" in sample:
        rr.log_tensor("robot/state", sample["observation.state"])
```

---

## 上传数据集到 Hub

### 自动上传（录制时）

```bash
lerobot-record \
    --repo-id ${HF_USER}/my_dataset \
    --dataset.push_to_hub=true
```

### 手动上传

```python
from lerobot import LeRobotDataset

# 加载本地数据集
dataset = LeRobotDataset.from_repo_id(f"{HF_USER}/my_dataset")

# 上传到 Hub
dataset.push_to_hub(
    repo_id=f"{HF_USER}/my_dataset",
    private=False,
    commit_message="Initial upload",
)
```

### 上传时添加元数据

```python
dataset.push_to_hub(
    repo_id=f"{HF_USER}/my_dataset",
    tags=["lerobot", "tutorial", "so101"],
    metadata={
        "robot_type": "so101",
        "task": "pick_and_place",
    },
)
```

---

## 克隆和下载数据集

```python
from lerobot import LeRobotDataset

# 克隆数据集到本地
dataset = LeRobotDataset.clone_from_hub(
    repo_id="lerobot/pusht",
    local_dir="~/datasets/pusht",
)
```

---

## 数据集转换

### 从其他格式转换

```python
from lerobot.common.datasets.format_converter import convert_datasets

# 转换 DAPG 格式数据集
convert_datasets(
    input_path="~/datasets/dapg",
    output_path="~/datasets/lerobot_format",
    input_format="dapg",
)
```

---

## 常见问题

### Q: 如何处理大型视频数据集？

**建议**：
1. 使用流式加载（避免完整加载到内存）
2. 利用 Hub 的压缩格式
3. 使用 `num_workers` 并行加载

### Q: 数据集加载很慢？

**解决**：
1. 使用 SSD 存储本地缓存
2. 增加 `num_workers` 数量
3. 预加载到内存（如果有足够 RAM）

### Q: 如何分割训练/测试集？

```python
from lerobot import LeRobotDataset

dataset = LeRobotDataset.from_repo_id("lerobot/pusht")

# 分割
train_size = int(len(dataset) * 0.8)
train_dataset = dataset[:train_size]
test_dataset = dataset[train_size:]
```

---

## 相关文档

- [录制数据集](../00_开始使用/03_机器人的模仿学习.md)
- [移植大型数据集](02_移植大型数据集.md)
- [数据集工具](03_数据集工具.md)

---

（来源：v0.5.1 数据集文档）