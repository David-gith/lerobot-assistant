# PyTorch 加速器

> 来源：LeRobot v0.5.1 PyTorch accelerators  
> https://huggingface.co/docs/lerobot/pytorch_accelerators

## 适用场景

用户询问 CUDA、MPS、CPU、训练设备选择或 PyTorch 加速器兼容性。

## 快速判断

- NVIDIA GPU：优先使用 `--policy.device=cuda`。
- Apple Silicon：可尝试 `--policy.device=mps`。
- CPU：适合轻量调试，不适合大规模训练。

## 检查命令

```bash
python -c "import torch; print(torch.cuda.is_available()); print(torch.backends.mps.is_available() if hasattr(torch.backends, 'mps') else False)"
nvidia-smi
```

## 排查

- CUDA 不可用：检查驱动、PyTorch CUDA 版本和容器/环境变量。
- MPS 报错：尝试 CPU smoke test，必要时降级模型或 batch。
- OOM：降低 batch size、分辨率或启用混合精度。

（来源：PyTorch accelerators）
