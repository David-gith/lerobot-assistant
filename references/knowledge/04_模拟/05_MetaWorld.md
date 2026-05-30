# Meta-World 基准

> 来源：LeRobot v0.5.1 Meta-World  
> https://huggingface.co/docs/lerobot/metaworld

## 适用场景

用户要在 Meta-World 任务上训练或评估策略。

## 建议流程

1. 安装 Meta-World 相关依赖。
2. 选择任务或任务集合。
3. 确认 observation/action 空间和奖励。
4. 先短跑验证环境稳定，再做正式评估。

## 常见问题

- MuJoCo/渲染报错：检查系统图形依赖和无头配置。
- 成功率波动大：增加 episode 数并固定 seed。

（来源：Meta-World）
