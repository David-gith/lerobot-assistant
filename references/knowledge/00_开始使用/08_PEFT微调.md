# PEFT / LoRA 微调

> 来源：LeRobot v0.5.1 Training with PEFT (e.g., LoRA)  
> https://huggingface.co/docs/lerobot/peft_training

## 适用场景

用户想低成本微调较大的策略模型，或显存不足以全量训练。

## 核心思路

- PEFT 只训练少量可学习参数，冻结大部分基础模型权重。
- LoRA 适合在有限数据和显存下做任务适配。
- 微调前应确认数据集任务描述、相机视角、动作空间与基础模型兼容。

## 建议回答模板

1. 先确认目标 policy 是否支持 PEFT/LoRA 参数。
2. 检查显存和 batch size。
3. 用小步数 smoke test 验证训练可启动。
4. 再增加训练步数并开启评估。

## 常见问题

- loss 不稳定：减小学习率或 batch size。
- 微调后效果差：检查任务文字描述、数据质量和动作归一化。
- 显存仍不足：使用更小模型、梯度检查点或混合精度。

（来源：Training with PEFT）
