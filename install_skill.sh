#!/usr/bin/env bash
# =============================================================================
# install_skill.sh - lerobot-assistant Skill installer
# Usage:
#   Put this script and lerobot_assistant_skill.tar.gz in the target project root,
#   then run: bash install_skill.sh
# =============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn() { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error() { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
die() { error "$*"; exit 1; }

SKILL_NAME="lerobot-assistant"
TARBALL="lerobot_assistant_skill.tar.gz"
INSTALL_DIR=".comate/skills"
TARGET_DIR="${INSTALL_DIR}/${SKILL_NAME}"

echo ""
echo -e "${BOLD}=================================================${RESET}"
echo -e "${BOLD}   LeRobot Assistant Skill Installer             ${RESET}"
echo -e "${BOLD}=================================================${RESET}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
info "Current directory: $(pwd)"

if [[ ! -f "$TARBALL" ]]; then
    die "Missing ${TARBALL}. Put it next to install_skill.sh and retry."
fi
success "Found tarball: ${TARBALL}"

if [[ -d "$TARGET_DIR" ]]; then
    BACKUP="${TARGET_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
    warn "Existing skill found. Backing it up to: ${BACKUP}"
    mv "$TARGET_DIR" "$BACKUP"
fi

mkdir -p "$INSTALL_DIR"
info "Install directory: ${INSTALL_DIR}"

info "Extracting ${TARBALL} ..."
tar -zxf "$TARBALL" -C "$INSTALL_DIR"

REQUIRED_FILES=(
    "README.md"
    "SKILL.md"
    "USAGE.md"
    "_meta.json"
    "config.yaml"
    "scripts/env_check.sh"
    "scripts/install_guide.md"
    "scripts/render_so101_config.py"
    "templates/so101_config.yaml"
    "references/knowledge_index.md"
)

ALL_OK=true
for f in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "${TARGET_DIR}/${f}" ]]; then
        error "Missing required file: ${TARGET_DIR}/${f}"
        ALL_OK=false
    fi
done

if [[ ! -d "${TARGET_DIR}/references/knowledge" ]]; then
    error "Missing knowledge directory: ${TARGET_DIR}/references/knowledge"
    ALL_OK=false
fi

if [[ "$ALL_OK" != "true" ]]; then
    die "Install validation failed. The tarball may be incomplete."
fi

VERSION=""
if command -v python3 >/dev/null 2>&1; then
    VERSION="$(python3 -c "import json; print(json.load(open('${TARGET_DIR}/_meta.json')).get('version',''))" 2>/dev/null || true)"
fi
VERSION_STR="${VERSION:+ v${VERSION}}"

echo ""
echo -e "${GREEN}${BOLD}========================================${RESET}"
echo -e "${GREEN}${BOLD}  Skill installed successfully${VERSION_STR}  ${RESET}"
echo -e "${GREEN}${BOLD}========================================${RESET}"
echo ""
echo -e "  Path: ${BOLD}${TARGET_DIR}${RESET}"
echo ""
echo -e "  ${BOLD}Try:${RESET}"
echo -e "  ${CYAN}/lerobot-env check${RESET}"
echo -e "  ${CYAN}帮我检查 LeRobot 环境${RESET}"
echo -e "  ${CYAN}SO-101 怎么校准？${RESET}"
echo ""
