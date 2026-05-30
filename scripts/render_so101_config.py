#!/usr/bin/env python3
"""Render the SO-101/S101 configuration template with safe defaults."""

from __future__ import annotations

import argparse
from pathlib import Path


DEFAULTS = {
    "robot_id": "my_so101",
    "robot_port": "/dev/ttyUSB0",
    "teleop_id": "my_so101_leader",
    "teleop_port": "/dev/ttyUSB1",
    "camera_index": "0",
    "camera_width": "640",
    "camera_height": "480",
    "camera_fps": "30",
    "dataset_repo_id": "YOUR_USER/so101_dataset",
    "dataset_fps": "30",
    "warmup_time_s": "5",
    "episode_time_s": "60",
    "reset_time_s": "30",
    "num_episodes": "10",
    "push_to_hub": "false",
}


def render_template(template: str, values: dict[str, str]) -> str:
    output = template
    for key, value in values.items():
        output = output.replace("{{" + key + "}}", value)
    unresolved = sorted(part.split("}}", 1)[0] for part in output.split("{{")[1:])
    if unresolved:
        raise ValueError(f"Unresolved template variables: {', '.join(unresolved)}")
    return output


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Render SO-101/S101 LeRobot config.")
    parser.add_argument("--template", default="templates/so101_config.yaml")
    parser.add_argument("--output", default="-", help="Output path, or '-' for stdout.")
    parser.add_argument("--robot-id", default=DEFAULTS["robot_id"])
    parser.add_argument("--robot-port", default=DEFAULTS["robot_port"])
    parser.add_argument("--teleop-id", default=DEFAULTS["teleop_id"])
    parser.add_argument("--teleop-port", default=DEFAULTS["teleop_port"])
    parser.add_argument("--camera-index", default=DEFAULTS["camera_index"])
    parser.add_argument("--camera-width", default=DEFAULTS["camera_width"])
    parser.add_argument("--camera-height", default=DEFAULTS["camera_height"])
    parser.add_argument("--camera-fps", default=DEFAULTS["camera_fps"])
    parser.add_argument("--dataset-repo-id", default=DEFAULTS["dataset_repo_id"])
    parser.add_argument("--dataset-fps", default=DEFAULTS["dataset_fps"])
    parser.add_argument("--warmup-time-s", default=DEFAULTS["warmup_time_s"])
    parser.add_argument("--episode-time-s", default=DEFAULTS["episode_time_s"])
    parser.add_argument("--reset-time-s", default=DEFAULTS["reset_time_s"])
    parser.add_argument("--num-episodes", default=DEFAULTS["num_episodes"])
    parser.add_argument("--push-to-hub", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    values = {
        "robot_id": args.robot_id,
        "robot_port": args.robot_port,
        "teleop_id": args.teleop_id,
        "teleop_port": args.teleop_port,
        "camera_index": args.camera_index,
        "camera_width": args.camera_width,
        "camera_height": args.camera_height,
        "camera_fps": args.camera_fps,
        "dataset_repo_id": args.dataset_repo_id,
        "dataset_fps": args.dataset_fps,
        "warmup_time_s": args.warmup_time_s,
        "episode_time_s": args.episode_time_s,
        "reset_time_s": args.reset_time_s,
        "num_episodes": args.num_episodes,
        "push_to_hub": "true" if args.push_to_hub else "false",
    }
    template = Path(args.template).read_text(encoding="utf-8")
    rendered = render_template(template, values)

    if args.output == "-":
        print(rendered, end="")
    else:
        Path(args.output).write_text(rendered, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
