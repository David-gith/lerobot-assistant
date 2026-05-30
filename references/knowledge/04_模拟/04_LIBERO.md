# LIBERO 基准

> 来源：LeRobot v0.5.1 LIBERO  
> https://huggingface.co/docs/lerobot/libero

## 适用场景

用户询问 LIBERO benchmark、语言条件任务或仿真评估。

## 建议

- 安装对应 benchmark 依赖。
- 确认任务 suite、数据集和策略输入字段。
- 使用固定 episode 数评估，保存日志和视频。

## 排查

- 环境导入失败：检查依赖和 Python 版本。
- 任务成功率低：确认动作尺度、图像预处理和任务文本。
- 运行慢：降低渲染分辨率或并行数。

（来源：LIBERO）
