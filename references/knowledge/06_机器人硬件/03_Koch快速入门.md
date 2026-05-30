# Koch v1.1 快速入门

> 来源：LeRobot v0.5.1 Koch v1.1  
> https://huggingface.co/docs/lerobot/koch

## 适用场景

用户使用 Koch v1.1 机械臂做遥操作、校准和数据采集。

## 要点

- Koch 使用 Dynamixel 相关支持。
- 注意 leader/follower 供电、电压和串口区分。
- Linux 下常见问题是 `/dev/ttyUSB*` 权限不足。

## 安装

```bash
pip install "lerobot[dynamixel]==0.5.1"
```

（来源：Koch v1.1）
