# 多 GPU 训练

> 来源：LeRobot v0.5.1 Multi GPU training  
> https://huggingface.co/docs/lerobot/multi_gpu_training

## 适用场景

用户要在多张 NVIDIA GPU 上加速训练或扩大 batch size。

## 关键检查

- 每张 GPU 都能被 `nvidia-smi` 看到。
- PyTorch CUDA 版本与驱动兼容。
- 数据集缓存位于高速磁盘，避免 dataloader 成为瓶颈。
- 日志和 checkpoint 目录对所有进程可写。

## 建议步骤

1. 先用单 GPU 跑通同一配置。
2. 再切换到分布式/多进程启动方式。
3. 保持全局 batch size、学习率和梯度累积策略一致。
4. 训练失败时先减小 batch size，再检查通信和 dataloader。

## 常见问题

- OOM：减小 per-device batch size 或启用梯度累积。
- 速度没有提升：检查 CPU、磁盘和数据增强开销。
- 只用到一张卡：检查启动命令和 `CUDA_VISIBLE_DEVICES`。

（来源：Multi GPU training）
