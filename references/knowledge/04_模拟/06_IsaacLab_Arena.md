# NVIDIA IsaacLab Arena

> 来源：LeRobot v0.5.1 NVIDIA IsaacLab Arena Environments  
> https://huggingface.co/docs/lerobot/isaaclab

## 适用场景

用户询问 IsaacLab Arena 环境、NVIDIA 仿真训练或评估。

## 建议

- 先确认 NVIDIA 驱动、CUDA、IsaacLab 版本匹配。
- 在无头/有头模式下分别测试环境启动。
- 训练前确认并行环境数不会压垮显存。

## 排查

- 启动失败：检查 GPU 驱动和 IsaacLab 安装。
- 渲染黑屏：检查图形后端和 DISPLAY。
- 速度慢：减少并行数、相机渲染或日志视频输出。

（来源：NVIDIA IsaacLab Arena Environments）
