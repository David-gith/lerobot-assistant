from __future__ import annotations

import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def test_env_check_json_is_machine_readable() -> None:
    result = subprocess.run(
        ["bash", "scripts/env_check.sh", "--json"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode in {0, 1, 2}
    payload = json.loads(result.stdout)
    assert "checks" in payload
    assert "overall_status" in payload
    assert payload["overall_status"] in {0, 1, 2}
    assert payload["checks"]["python"]["required"] is True


def test_env_check_shell_syntax() -> None:
    result = subprocess.run(
        ["bash", "-n", "scripts/env_check.sh"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
