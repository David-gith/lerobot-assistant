# X-VLA 策略

> 来源：LeRobot v0.5.1 X-VLA  
> https://huggingface.co/docs/lerobot/xvla

## 定位

X-VLA 是 LeRobot 文档中的视觉-语言-动作策略条目。用于跨任务、带语言条件的机器人策略咨询。

## 使用建议

1. 确认 LeRobot 版本包含该策略。
2. 检查数据集是否提供语言任务描述。
3. 对齐相机名、状态/action 维度和统计量。
4. 先小规模训练验证 pipeline。

## 排查

- 缺任务文本：补 `single_task` 或数据集任务字段。
- 输入维度不匹配：检查 features 和 rename map。
- 显存不足：降低分辨率、batch size 或使用混合精度。

（来源：X-VLA）
