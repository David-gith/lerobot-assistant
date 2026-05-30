# Real-Time Chunking (RTC)

> 来源：LeRobot v0.5.1 Real-Time Chunking  
> https://huggingface.co/docs/lerobot/rtc

## 适用场景

用户要在实时控制中执行分块动作，或遇到 action chunk 抖动、延迟和切换不平滑问题。

## 核心要点

- RTC 关注 chunk 生成、缓存和执行之间的时序关系。
- 需要平衡推理延迟、控制频率和动作平滑。
- 适合大模型推理和真机闭环控制。

## 排查

- 动作卡顿：检查推理是否慢于控制周期。
- 机器人抖动：调小 chunk 切换幅度或检查动作归一化。
- 队列堆积：降低生成速度或缩短缓存。

（来源：Real-Time Chunking）
