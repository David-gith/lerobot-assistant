#!/usr/bin/env bash
#
# LeRobot environment checker
# Usage: bash scripts/env_check.sh [--json]
#

set +e

JSON_OUTPUT=false
if [ "${1:-}" = "--json" ]; then
    JSON_OUTPUT=true
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

OVERALL_STATUS=0
RESULT_KEYS=()
declare -A STATUS_BY_KEY
declare -A LABEL_BY_KEY
declare -A MESSAGE_BY_KEY
declare -A REQUIRED_BY_KEY

json_escape() {
    local value="${1:-}"
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    value=${value//$'\r'/}
    printf '%s' "$value"
}

record_result() {
    local key="$1"
    local label="$2"
    local status="$3"
    local message="$4"
    local required="${5:-false}"

    RESULT_KEYS+=("$key")
    STATUS_BY_KEY["$key"]="$status"
    LABEL_BY_KEY["$key"]="$label"
    MESSAGE_BY_KEY["$key"]="$message"
    REQUIRED_BY_KEY["$key"]="$required"

    case "$status" in
        fail)
            OVERALL_STATUS=2
            ;;
        warn)
            if [ "$OVERALL_STATUS" -lt 2 ]; then
                OVERALL_STATUS=1
            fi
            ;;
    esac
}

python_bin() {
    if command -v python >/dev/null 2>&1; then
        command -v python
    elif command -v python3 >/dev/null 2>&1; then
        command -v python3
    else
        return 1
    fi
}

version_at_least() {
    local version="$1"
    local minimum="$2"
    local py
    py="$(python_bin)" || return 1
    "$py" - "$version" "$minimum" <<'PY' >/dev/null 2>&1
import re
import sys

def parts(value):
    match = re.match(r"(\d+)(?:\.(\d+))?(?:\.(\d+))?", value)
    if not match:
        raise SystemExit(1)
    nums = [int(item or 0) for item in match.groups()]
    return tuple(nums)

raise SystemExit(0 if parts(sys.argv[1]) >= parts(sys.argv[2]) else 1)
PY
}

print_header() {
    if [ "$JSON_OUTPUT" = true ]; then
        return
    fi
    printf '\n'
    printf "${YELLOW}========================================${NC}\n"
    printf "${YELLOW}  %s${NC}\n" "$1"
    printf "${YELLOW}========================================${NC}\n"
}

print_human_results() {
    print_header "LeRobot 环境检测"

    local key status label message
    for key in "${RESULT_KEYS[@]}"; do
        status="${STATUS_BY_KEY[$key]}"
        label="${LABEL_BY_KEY[$key]}"
        message="${MESSAGE_BY_KEY[$key]}"
        case "$status" in
            pass)
                printf "  ✅ %s: ${GREEN}%s${NC}\n" "$label" "$message"
                ;;
            warn)
                printf "  ⚠️  %s: ${YELLOW}%s${NC}\n" "$label" "$message"
                ;;
            fail)
                printf "  ❌ %s: ${RED}%s${NC}\n" "$label" "$message"
                ;;
        esac
    done

    print_header "检测完成"
    case "$OVERALL_STATUS" in
        0)
            printf "${GREEN}✅ 所有检查通过！可以开始使用 LeRobot。${NC}\n"
            ;;
        1)
            printf "${YELLOW}⚠️  存在警告项，但可以继续。${NC}\n"
            ;;
        2)
            printf "${RED}❌ 存在必须修复的问题，请先解决后再继续。${NC}\n"
            ;;
    esac
}

print_json_results() {
    local key status label message required comma

    printf '{\n'
    printf '  "checks": {\n'
    comma=""
    for key in "${RESULT_KEYS[@]}"; do
        status="${STATUS_BY_KEY[$key]}"
        label="${LABEL_BY_KEY[$key]}"
        message="${MESSAGE_BY_KEY[$key]}"
        required="${REQUIRED_BY_KEY[$key]}"
        printf '%s    "%s": {"label": "%s", "status": "%s", "required": %s, "message": "%s"}' \
            "$comma" \
            "$(json_escape "$key")" \
            "$(json_escape "$label")" \
            "$(json_escape "$status")" \
            "$required" \
            "$(json_escape "$message")"
        comma=",
"
    done
    printf '\n'
    printf '  },\n'
    printf '  "overall_status": %s\n' "$OVERALL_STATUS"
    printf '}\n'
}

detect_python() {
    local py version
    py="$(python_bin)"
    if [ -z "$py" ]; then
        record_result "python" "Python 版本" "fail" "未找到 python 或 python3" "true"
        return
    fi

    version="$("$py" -c 'import platform; print(platform.python_version())' 2>/dev/null)"
    if version_at_least "$version" "3.12"; then
        record_result "python" "Python 版本" "pass" "$version (>= 3.12)" "true"
    else
        record_result "python" "Python 版本" "fail" "$version (需要 >= 3.12)" "true"
    fi
}

detect_conda() {
    if command -v conda >/dev/null 2>&1; then
        record_result "conda" "Conda/Mamba" "pass" "conda 已安装" "false"
    elif command -v mamba >/dev/null 2>&1; then
        record_result "conda" "Conda/Mamba" "pass" "mamba 已安装" "false"
    else
        record_result "conda" "Conda/Mamba" "warn" "未安装；推荐使用 miniforge/conda 管理 LeRobot 环境" "false"
    fi
}

detect_git() {
    local version
    if command -v git >/dev/null 2>&1; then
        version="$(git --version 2>/dev/null)"
        record_result "git" "Git" "pass" "$version" "false"
    else
        record_result "git" "Git" "warn" "未安装；源码安装需要 git" "false"
    fi
}

detect_lerobot() {
    local py version
    py="$(python_bin)" || {
        record_result "lerobot" "LeRobot" "warn" "跳过；未找到 Python" "false"
        return
    }

    if "$py" -c "import lerobot" >/dev/null 2>&1; then
        version="$("$py" -c 'import lerobot; print(getattr(lerobot, "__version__", "unknown"))' 2>/dev/null)"
        record_result "lerobot" "LeRobot" "pass" "已安装 v$version" "false"
    else
        record_result "lerobot" "LeRobot" "warn" "未安装" "false"
    fi
}

detect_pytorch() {
    local py version
    py="$(python_bin)" || {
        record_result "pytorch" "PyTorch" "warn" "跳过；未找到 Python" "false"
        return
    }

    if "$py" -c "import torch" >/dev/null 2>&1; then
        version="$("$py" -c 'import torch; print(torch.__version__)' 2>/dev/null)"
        if version_at_least "$version" "2.10.0"; then
            record_result "pytorch" "PyTorch" "pass" "v$version" "false"
        else
            record_result "pytorch" "PyTorch" "warn" "v$version；LeRobot v0.5.1 建议 >= 2.10" "false"
        fi
    else
        record_result "pytorch" "PyTorch" "warn" "未安装；安装 LeRobot 时通常会带入核心依赖" "false"
    fi
}

detect_gpu() {
    local gpu_name gpu_memory gpu_memory_gb mps_available py

    if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L >/dev/null 2>&1; then
        gpu_name="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n 1)"
        gpu_memory="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -n 1)"
        if [[ "$gpu_memory" =~ ^[0-9]+$ ]]; then
            gpu_memory_gb=$((gpu_memory / 1024))
            if [ "$gpu_memory_gb" -ge 8 ]; then
                record_result "gpu" "GPU" "pass" "$gpu_name (${gpu_memory_gb}GB)" "false"
            else
                record_result "gpu" "GPU" "warn" "$gpu_name (${gpu_memory_gb}GB；训练建议 8GB+)" "false"
            fi
        else
            record_result "gpu" "GPU" "warn" "$gpu_name；无法读取显存信息" "false"
        fi
        return
    fi

    py="$(python_bin)"
    if [ -n "$py" ]; then
        mps_available="$("$py" -c 'import torch; print(torch.backends.mps.is_available())' 2>/dev/null)"
        if [ "$mps_available" = "True" ]; then
            record_result "gpu" "GPU" "pass" "Apple MPS 可用" "false"
            return
        fi
    fi

    record_result "gpu" "GPU" "warn" "未检测到可用 NVIDIA GPU 或 Apple MPS；CPU 可用于轻量测试" "false"
}

detect_ffmpeg() {
    local version
    if command -v ffmpeg >/dev/null 2>&1; then
        version="$(ffmpeg -version 2>/dev/null | head -n 1)"
        record_result "ffmpeg" "ffmpeg" "pass" "$version" "false"
    else
        record_result "ffmpeg" "ffmpeg" "warn" "未安装；视频解码/录制工作流通常需要 ffmpeg 或 PyAV fallback" "false"
    fi
}

detect_usb() {
    case "$(uname -s)" in
        Linux)
            if compgen -G "/dev/ttyUSB*" >/dev/null || compgen -G "/dev/ttyACM*" >/dev/null; then
                record_result "usb" "USB 串口" "pass" "检测到串口设备" "false"
            else
                record_result "usb" "USB 串口" "warn" "未检测到串口设备；未连接机器人时正常" "false"
            fi
            ;;
        Darwin)
            if compgen -G "/dev/tty.usb*" >/dev/null; then
                record_result "usb" "USB 串口" "pass" "检测到 USB 串口设备" "false"
            else
                record_result "usb" "USB 串口" "warn" "未检测到 USB 串口设备；未连接机器人时正常" "false"
            fi
            ;;
        *)
            record_result "usb" "USB 串口" "warn" "当前系统未做串口自动检测；Windows 建议使用 WSL2" "false"
            ;;
    esac
}

detect_hf_cli() {
    if command -v huggingface-cli >/dev/null 2>&1; then
        record_result "hf_cli" "Hugging Face CLI" "pass" "huggingface-cli 已安装" "false"
    else
        record_result "hf_cli" "Hugging Face CLI" "warn" "未检测到 huggingface-cli；上传数据集前需安装/登录" "false"
    fi
}

main() {
    detect_python
    detect_conda
    detect_git
    detect_lerobot
    detect_pytorch
    detect_gpu
    detect_ffmpeg
    detect_usb
    detect_hf_cli

    if [ "$JSON_OUTPUT" = true ]; then
        print_json_results
    else
        print_human_results
    fi

    exit "$OVERALL_STATUS"
}

main
