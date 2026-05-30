# Pi0-FAST 策略

> 来源：LeRobot v0.5.1 π₀-FAST (Pi0Fast)  
> https://huggingface.co/docs/lerobot/pi0fast

## 定位

Pi0-FAST 是视觉-语言-动作模型，使用 FAST 动作 tokenization，把连续动作压缩成适合自回归预测的 token。

## 安装

```bash
pip install -e ".[pi]"
```

## 使用

```bash
lerobot-train \
  --dataset.repo_id=your_dataset \
  --policy.type=pi0_fast \
  --policy.pretrained_path=lerobot/pi0_fast_base \
  --policy.device=cuda
```

## Tokenizer

- 可使用通用预训练 tokenizer。
- 也可用自己的 LeRobotDataset 训练 FAST tokenizer。
- 关键参数包括 action horizon、编码维度、vocab size、normalization mode。

## 排查

- 动作 token 质量差：检查动作维度范围和 normalization。
- 显存不足：启用 bfloat16、梯度检查点，减小 batch size。
- 训练慢：检查数据加载和 tokenizer 设置。

（来源：π₀-FAST Pi0Fast）
