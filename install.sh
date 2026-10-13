#!/usr/bin/env bash
# ==============================================================================
# hyprland-skill installer
# Automated setup and symlink configuration
# ==============================================================================
set -euo pipefail

SKILL_REPO_URL="https://github.com/rhythmcreative/hyprland-skill.git"

# Detect real target user and home if executed with sudo
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "$TARGET_USER" 2>/dev/null | cut -d: -f6 || echo "$HOME")

INSTALL_DIR="${TARGET_HOME}/.local/share/hyprland-skill"
ALT_INSTALL_DIR="${TARGET_HOME}/hyprland-skill"

BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

echo -e "${BLUE}==>${RESET} ${BOLD}Installing or updating hyprland-skill...${RESET}"

# 1. Clone or update repository
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "  -> Updating existing skill repository in ${CYAN}${INSTALL_DIR}${RESET}..."
    git -C "$INSTALL_DIR" pull --ff-only origin main
elif [ -d "$ALT_INSTALL_DIR/.git" ]; then
    echo -e "  -> Using existing local workspace in ${CYAN}${ALT_INSTALL_DIR}${RESET}..."
    INSTALL_DIR="$ALT_INSTALL_DIR"
else
    echo -e "  -> Cloning skill repository to ${CYAN}${INSTALL_DIR}${RESET}..."
    mkdir -p "$(dirname "$INSTALL_DIR")"
    git clone --depth 1 "$SKILL_REPO_URL" "$INSTALL_DIR"
fi

# 2. Make helper scripts executable
echo -e "${BLUE}==>${RESET} ${BOLD}Setting executable permissions on helper scripts...${RESET}"
chmod +x "$INSTALL_DIR"/scripts/* 2>/dev/null || true

# 3. Configure discovery symlinks
echo -e "${BLUE}==>${RESET} ${BOLD}Configuring skill discovery paths...${RESET}"

link_skill() {
    local target_dir="$1"
    local name="$2"
    mkdir -p "$target_dir"
    ln -sfn "$INSTALL_DIR" "$target_dir/$name"
    if [ -n "${SUDO_USER:-}" ]; then
        chown -h "$TARGET_USER:$TARGET_USER" "$target_dir/$name" 2>/dev/null || true
        chown -R "$TARGET_USER:$TARGET_USER" "$target_dir" 2>/dev/null || true
    fi
    echo -e "  ${GREEN}[OK]${RESET} Linked ${BOLD}$name${RESET} -> ${target_dir}"
}

# Global configurations
link_skill "${TARGET_HOME}/.gemini/config/skills" "hyprland-skill"
link_skill "${TARGET_HOME}/.agents/skills" "hyprland-skill"
link_skill "${TARGET_HOME}/.claude/skills" "hyprland-skill"

# Workspace level if rhythmcreative/hyprland exists
if [ -d "${TARGET_HOME}/hyprland" ]; then
    link_skill "${TARGET_HOME}/hyprland/.agents/skills" "hyprland-skill"
fi

if [ -n "${SUDO_USER:-}" ] && [ -d "$INSTALL_DIR" ]; then
    chown -R "$TARGET_USER:$TARGET_USER" "$INSTALL_DIR" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}${BOLD}Installation completed successfully.${RESET}"
echo ""
echo -e "Available tools:"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/sync-status${RESET}      - Verify file sync between repo and system"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/reload-desktop${RESET}    - Safely reload Hyprland, Quickshell, and Hypridle"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/capture-ui bar${RESET}    - Verify UI layout with instant grim capture"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/test-battery${RESET}      - Inspect battery sensors and AC state"
echo ""
