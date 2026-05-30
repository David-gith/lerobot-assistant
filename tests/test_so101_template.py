from __future__ import annotations

import importlib.util
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "render_so101_config.py"
TEMPLATE = ROOT / "templates" / "so101_config.yaml"


def load_renderer():
    spec = importlib.util.spec_from_file_location("render_so101_config", SCRIPT)
    assert spec is not None
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_so101_template_has_no_unknown_variables_after_render() -> None:
    renderer = load_renderer()
    template = TEMPLATE.read_text(encoding="utf-8")
    rendered = renderer.render_template(template, renderer.DEFAULTS)

    assert "{{" not in rendered
    assert "so101_follower" in rendered
    assert "so101_leader" in rendered
    assert "/dev/ttyUSB0" in rendered


def test_so101_renderer_cli_overrides_values() -> None:
    result = subprocess.run(
        [
            "python3",
            "scripts/render_so101_config.py",
            "--robot-id",
            "bench_arm",
            "--robot-port",
            "/dev/ttyACM0",
            "--dataset-repo-id",
            "user/bench_dataset",
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    assert "bench_arm" in result.stdout
    assert "/dev/ttyACM0" in result.stdout
    assert "user/bench_dataset" in result.stdout
