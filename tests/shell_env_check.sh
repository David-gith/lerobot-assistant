#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

bash -n scripts/env_check.sh
bash scripts/env_check.sh --json > /tmp/lerobot_env_check_test.json || status=$?
status="${status:-0}"

if [ "$status" -ne 0 ] && [ "$status" -ne 1 ] && [ "$status" -ne 2 ]; then
    echo "unexpected env_check exit status: $status" >&2
    exit 1
fi

python3 -m json.tool /tmp/lerobot_env_check_test.json >/dev/null
python3 scripts/render_so101_config.py --robot-id shell_test >/tmp/so101_config_test.yaml
grep -q "shell_test" /tmp/so101_config_test.yaml
