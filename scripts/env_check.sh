#!/bin/bash
#
# LeRobot 环境检测脚本
# 用法: bash env_check.sh [--json]
#

set +e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 输出格式
JSON_OUTPUT=false
if [ "$1" == "--json" ]; then
    JSON_OUTPUT=true
fi

# 检测结果
declare -A CHECKS
OVERALL_STATUS=0

check() {
    local name="$1"
    local command="$2"
    local required="${3:-false}"

    if eval "$command" > /dev/null 2>&1; then
        CHECKS["$name"]="pass"
        if [ "$required" == "true" ]; then
            :
        fi
    else
        if [ "$required" == "true" ]; then
            CHECKS["$name"]="fail"
            OVERALL_STATUS=2
        else
            CHECKS["$name"]="warn"
            if [ $OVERALL_STATUS -lt 2 ]; then
                OVERALL_STATUS=1
            fi
        fi
    fi
}

echo_header() {
    local text="$1"
    if [ "$JSON_OUTPUT" == "true" ]; then
        return
    fi
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  $text${NC}"
    echo -e "${YELLOW}========================================${NC}"
}

print_result() {
    local check_name="$1"
    local status="$2"
    local message="$3"

    if [ "$JSON_OUTPUT" == "true" ]; then
        return
    fi

    case "$status" in
        pass)
            echo -e "  ✅ $check_name: ${GREEN}$message${NC}"
            ;;
        warn)
            echo -e "  ⚠️  $check_name: ${YELLOW}$message${NC}"
            ;;
        fail)
            echo -e "  ❌ $check_name: ${RED}$message${NC}"
            ;;
    esac
}

# 主检测逻辑
main() {
    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "{"
        echo "  \"checks\": {"
    else
        echo_header "LeRobot 环境检测"
    fi

    local first=true
    local all_checks=""

    # 1. Python 版本检测
    check_name="Python 版本"
    if command -v python > /dev/null 2>&1; then
        python_version=$(python --version 2>&1 | grep -oP '\d+\.\d+')
        major=$(echo $python_version | cut -d. -f1)
        minor=$(echo $python_version | cut -d. -f2)

        if [ "$major" -ge 3 ] && [ "$minor" -ge 12 ]; then
            status="pass"
            message="Python $python_version (>= 3.12)"
        else
            status="fail"
            message="Python $python_version (需要 >= 3.12)"
            OVERALL_STATUS=2
        fi
    else
        status="fail"
        message="未找到 Python"
        OVERALL_STATUS=2
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"python_version\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 2. Conda 检测
    check_name="Conda/Mamba"
    if command -v conda > /dev/null 2>&1; then
        status="pass"
        message="已安装"
    elif command -v mamba > /dev/null 2>&1; then
        status="pass"
        message="已安装 (mamba)"
    else
        status="warn"
        message="未安装（可选，推荐使用）"
        [ $OVERALL_STATUS -lt 1 ] && OVERALL_STATUS=1
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"conda\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 3. Git 检测
    check_name="Git"
    if command -v git > /dev/null 2>&1; then
        git_version=$(git --version | grep -oP '\d+\.\d+')
        status="pass"
        message="已安装 v$git_version"
    else
        status="warn"
        message="未安装（源码安装需要）"
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"git\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 4. LeRobot 安装检测
    check_name="LeRobot"
    if python -c "import lerobot" 2>/dev/null; then
        version=$(python -c "import lerobot; print(lerobot.__version__)")
        status="pass"
        message="已安装 v$version"
    else
        status="warn"
        message="未安装"
        [ $OVERALL_STATUS -lt 1 ] && OVERALL_STATUS=1
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"lerobot\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 5. PyTorch 检测
    check_name="PyTorch"
    if python -c "import torch" 2>/dev/null; then
        torch_version=$(python -c "import torch; print(torch.__version__)")
        if python -c "import torch; assert tuple(map(int, torch.__version__.split('.')[:2])) >= (2, 10)" 2>/dev/null; then
            status="pass"
            message="v$torch_version"
        else
            status="warn"
            message="v$torch_version (建议 >= 2.10)"
        fi
    else
        status="fail"
        message="未安装（LeRobot 核心依赖）"
        [ $OVERALL_STATUS -lt 2 ] && OVERALL_STATUS=2
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"pytorch\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 6. CUDA/GPU 检测
    check_name="GPU"
    if command -v nvidia-smi > /dev/null 2>&1; then
        gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
        gpu_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader 2>/dev/null | head -1 | sed 's/ MiB//')
        gpu_memory_gb=$((gpu_memory / 1024))

        if [ $gpu_memory_gb -ge 8 ]; then
            status="pass"
            message="$gpu_name (${gpu_memory_gb}GB)"
        else
            status="warn"
            message="$gpu_name (${gpu_memory_gb}GB, 建议 8GB+)"
            [ $OVERALL_STATUS -lt 1 ] && OVERALL_STATUS=1
        fi
    else
        # 检查 MPS (macOS)
        if python -c "import torch; print(torch.backends.mps.is_available())" 2>/dev/null | grep -q "True"; then
            status="pass"
            message="Apple MPS 可用 (macOS)"
        else
            status="warn"
            message="未检测到 GPU（训练需要 NVIDIA GPU 或 Apple MPS）"
            [ $OVERALL_STATUS -lt 1 ] && OVERALL_STATUS=1
        fi
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"gpu\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 7. ffmpeg 检测
    check_name="ffmpeg"
    if command -v ffmpeg > /dev/null 2>&1; then
        ffmpeg_version=$(ffmpeg -version 2>&1 | grep -oP 'ffmpeg version \K[\d.]+')
        status="pass"
        message="v$ffmpeg_version"
    else
        status="warn"
        message="未安装（Linux 录制视频需要）"
        [ $OVERALL_STATUS -lt 1 ] && OVERALL_STATUS=1
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"ffmpeg\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 8. USB 端口检测（Linux）
    check_name="USB 设备"
    if [ "$(uname)" == "Linux" ]; then
        if ls /dev/ttyUSB* > /dev/null 2>&1 || ls /dev/ttyACM* > /dev/null 2>&1; then
            status="pass"
            message="检测到串口设备"
        else
            status="warn"
            message="未检测到串口设备（连接机器人前不会有）"
        fi
    elif [ "$(uname)" == "Darwin" ]; then
        if ls /dev/tty.usbmodem* > /dev/null 2>&1; then
            status="pass"
            message="检测到 USB 调制解调器设备"
        else
            status="warn"
            message="未检测到 USB 设备"
        fi
    else
        status="warn"
        message="Windows 检测跳过（建议使用 WSL2）"
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"usb\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 9. Hugging Face CLI 检测
    check_name="HF CLI"
    if python -c "from huggingface_hub import hf_hub_download" 2>/dev/null; then
        status="pass"
        message="已安装"
    else
        status="warn"
        message="未安装（上传数据集需要）"
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"hf_cli\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 10. LeRobot 版本检查
    check_name="LeRobot 版本"
    if python -c "import lerobot" 2>/dev/null; then
        lerobot_version=$(python -c "import lerobot; print(lerobot.__version__)" 2>/dev/null)
        if [ -n "$lerobot_version" ]; then
            # 检查是否为稳定版 v0.5.1
            if [ "$lerobot_version" == "0.5.1" ]; then
                status="pass"
                message="v$lerobot_version (稳定版)"
            elif [[ "$lerobot_version" == *"+"* ]] || [[ "$lerobot_version" == *"git"* ]]; then
                status="pass"
                message="v$lerobot_version (开发版/源码)"
            else
                status="warn"
                message="v$lerobot_version (建议升级到 v0.5.1 稳定版)"
            fi
        else
            status="warn"
            message="无法获取版本信息"
        fi
    else
        status="warn"
        message="未安装"
    fi

    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "    \"lerobot_version\": {\"status\": \"$status\", \"message\": \"$message\"}"
    else
        print_result "$check_name" "$status" "$message"
    fi

    # 输出 JSON 结束
    if [ "$JSON_OUTPUT" == "true" ]; then
        echo "  },"
        echo "  \"overall_status\": $OVERALL_STATUS"
        echo "}"
    else
        echo ""
        echo_header "检测完成"
        case $OVERALL_STATUS in
            0)
                echo -e "${GREEN}✅ 所有检查通过！可以开始使用 LeRobot。${NC}"
                ;;
            1)
                echo -e "${YELLOW}⚠️  存在警告项，但可以继续。${NC}"
                ;;
            2)
                echo -e "${RED}❌ 存在必须修复的问题，请先解决后再继续。${NC}"
                ;;
        esac
    fi

    exit $OVERALL_STATUS
}

main