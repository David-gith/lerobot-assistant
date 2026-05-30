# LeRobot Knowledge Index

Local knowledge base for the `lerobot-assistant` skill. Content is based on Hugging Face LeRobot v0.5.1 documentation and selected local workflow notes.

> Stable version: `0.5.1`  
> Official docs index: https://huggingface.co/docs/lerobot/index  
> Version used: `v0.5.1`

## Coverage

Current local knowledge files: 58.

| Category | Files | Main use |
| --- | ---: | --- |
| `00_开始使用/` | 9 | install, imitation learning, custom policy/hardware, RL, PEFT |
| `01_数据集/` | 5 | LeRobotDataset, migration, tools, subtasks, video encoding |
| `02_策略/` | 10 | ACT, SmolVLA, Pi family, GR00T, X-VLA, WALL-OSS, SARM |
| `03_推理/` | 2 | async inference, RTC |
| `04_模拟/` | 6 | Hub environments, LeIsaac, LIBERO, Meta-World, IsaacLab |
| `05_机器人处理器/` | 6 | processors, debugging, custom processors, action representations |
| `06_机器人硬件/` | 10 | SO-101, SO-100, Koch, LeKiwi, Reachy, Unitree, OpenArm |
| `07_遥操作员/` | 2 | teleoperation, phone teleoperator |
| `08_摄像头/` | 1 | camera configuration |
| `09_FAQ故障排查/` | 1 | common troubleshooting |
| `09_PyTorch加速器/` | 1 | CUDA/MPS/CPU accelerator checks |
| `10_资源与工具/` | 3 | notebooks, firmware, CAN bus |
| `11_关于/` | 2 | contribution, backward compatibility |

## Routing Map

| Query keywords | Search first |
| --- | --- |
| install, conda, pip, Python, PyTorch, ffmpeg | `00_开始使用/01_安装指南.md`, then FAQ |
| imitation learning, teleoperate → record → train | `00_开始使用/03_机器人的模仿学习.md` |
| custom policy, own algorithm | `00_开始使用/02_引入自己的策略.md` |
| custom hardware, unsupported robot | `00_开始使用/04_引入自己的硬件.md` |
| RL, reinforcement learning | `00_开始使用/05_强化学习训练.md`, `00_开始使用/06_模拟中训练强化学习.md` |
| PEFT, LoRA | `00_开始使用/08_PEFT微调.md` |
| rename map, empty camera | `00_开始使用/09_重命名映射与空相机.md` |
| dataset migration, dataset tools, subtasks, video encoding | `01_数据集/` |
| ACT, SmolVLA, Pi0, Pi0Fast, Pi05, GR00T, X-VLA, WALL-OSS | `02_策略/` |
| reward model, SARM | `02_策略/10_SARM奖励模型.md` |
| async inference, real-time chunking | `03_推理/` |
| PushT, Aloha, LeIsaac, LIBERO, Meta-World, IsaacLab | `04_模拟/` |
| processor, action representation, preprocessing | `05_机器人处理器/` |
| SO-101, SO101, S101, Feetech, USB, calibrate | `06_机器人硬件/01_SO101快速入门.md`, then FAQ |
| Koch, Dynamixel | `06_机器人硬件/03_Koch快速入门.md` |
| Unitree, Reachy, OpenArm, LeKiwi, OMX | `06_机器人硬件/` |
| phone teleop, teleoperator | `07_遥操作员/` |
| camera, RealSense, OpenCV, `/dev/video` | `08_摄像头/01_摄像头配置.md` |
| CUDA, MPS, accelerator, OOM | `09_PyTorch加速器/01_PyTorch加速器.md`, then FAQ |
| firmware, Feetech, CAN bus, Damiao | `10_资源与工具/` |
| old checkpoint, compatibility, migration | `11_关于/02_向后兼容.md` |

## Retrieval Procedure

1. Match aliases first, especially `S101` → `SO-101`.
2. Read the smallest relevant file.
3. Use `rg` in `references/knowledge/` if the route is unclear.
4. Answer with concrete steps and cite the local source file.
5. If local content is missing or version-sensitive, verify against official LeRobot docs or GitHub before finalizing.

## Official v0.5.1 Topics Reflected Locally

- Get started: LeRobot overview, installation.
- Tutorials: imitation learning, custom policies, custom hardware, RL, simulation RL, multi-GPU, PEFT, rename map/empty cameras.
- Datasets: LeRobotDataset, migration, tools, subtasks, streaming video encoding.
- Policies and reward models: ACT, SmolVLA, Pi0, Pi0Fast, Pi05, GR00T, X-VLA, Multitask DiT, WALL-OSS, SARM.
- Inference: async inference, real-time chunking.
- Simulation and benchmarks: Hub environments, LeIsaac, new benchmark, LIBERO, Meta-World, IsaacLab Arena.
- Robot processors: introduction, debugging, custom implementation, robot/teleop processors, environment processors, action representations.
- Robots, teleoperators, sensors, supported hardware, resources, and compatibility notes.
