# Multitask DiT Policy

> 来源：LeRobot v0.5.1 Multitask DiT Policy  
> https://huggingface.co/docs/lerobot/multitask_dit

## 定位

Multitask DiT 用于多任务策略训练场景。用户关注多任务、Diffusion Transformer 或任务条件策略时查本页。

## 使用建议

- 明确每条数据对应的任务标签或语言描述。
- 训练前检查各任务数据量是否严重不均衡。
- 多任务训练建议保留验证集，避免只优化高频任务。

## 排查

- 某些任务失败：检查采样权重和任务标签。
- 输入字段不一致：用 rename map 或数据集迁移统一字段。
- 训练慢：检查图像分辨率、batch size 和 dataloader。

（来源：Multitask DiT Policy）
