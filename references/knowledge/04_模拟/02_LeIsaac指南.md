# LeIsaac 仿真

> 来源：LeRobot v0.5.1 Control & Train Robots in Sim (LeIsaac)  
> https://huggingface.co/docs/lerobot/leisaac

## 适用场景

用户想在 Isaac/LeIsaac 相关仿真环境中控制和训练机器人。

## 建议流程

1. 安装 LeIsaac 及对应仿真依赖。
2. 先跑官方示例，确认环境能 reset 和 step。
3. 检查 observation/action 空间。
4. 训练前确认 GPU、驱动和仿真后端兼容。

## 常见问题

- 仿真启动失败：检查 NVIDIA 驱动、CUDA、Isaac 依赖。
- 渲染异常：检查图形环境和无头模式设置。
- 训练慢：降低并行环境数或渲染开销。

（来源：LeIsaac）
