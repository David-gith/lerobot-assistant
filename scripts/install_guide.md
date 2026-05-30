# lerobot-assistant Skill 安装说明

## 1. 文件准备

将以下两个文件放在目标项目根目录：

```text
install_skill.sh
lerobot_assistant_skill.tar.gz
```

目标项目根目录可以是你希望 AI 助手工作的任意项目目录。

## 2. 执行安装

```bash
bash install_skill.sh
```

安装脚本会执行以下操作：

1. 检查 `lerobot_assistant_skill.tar.gz` 是否存在。
2. 创建 `.comate/skills/` 目录。
3. 如果已安装旧版 `lerobot-assistant`，先备份为带时间戳的 `.bak` 目录。
4. 解压新的 Skill 到 `.comate/skills/lerobot-assistant/`。
5. 校验关键文件是否存在。

## 3. 安装结果

安装成功后，目录应类似：

```text
.comate/skills/lerobot-assistant/
├── README.md
├── SKILL.md
├── USAGE.md
├── _meta.json
├── config.yaml
├── references/
├── scripts/
└── templates/
```

## 4. 触发示例

可以通过命令触发：

```text
/lerobot-env check
/lerobot-env diagnose
```

也可以直接用自然语言提问：

```text
帮我检查 LeRobot 环境
SO-101 怎么校准？
LeRobot 录制数据集报 ffmpeg 错误怎么办？
如何先在 LIBERO 或 Meta-World 中评估策略？
```

## 5. 使用前检查

安装后可以运行环境检测：

```bash
bash .comate/skills/lerobot-assistant/scripts/env_check.sh
bash .comate/skills/lerobot-assistant/scripts/env_check.sh --json
```

退出码含义：

| 退出码 | 含义 |
| --- | --- |
| 0 | 必要检查通过 |
| 1 | 存在警告，轻量任务可继续 |
| 2 | 存在必须修复的问题 |

## 6. 注意事项

- Skill 本身不需要单独 Python 环境。
- 真正运行 LeRobot、PyTorch 或仿真任务时，建议创建独立 Python 3.12 环境。
- 涉及 `sudo`、安装系统包、访问机械臂硬件或上传 Hugging Face Hub 前，应先确认操作风险。
- 默认 SO-101/S101 模板不自动上传数据集，上传前应确认数据隐私和仓库权限。
