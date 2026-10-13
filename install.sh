#!/usr/bin/env bash
# ==============================================================================
# hyprland-skill installer
# Automated setup for Antigravity, Claude Code, OpenCode, and Codex agents
# ==============================================================================
set -euo pipefail

SKILL_REPO_URL="https://github.com/rhythmcreative/hyprland-skill.git"
INSTALL_DIR="${HOME}/.local/share/hyprland-skill"
ALT_INSTALL_DIR="${HOME}/hyprland-skill"

# Visual formatting
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
  _                              _                 _           _     _ _ _ 
 | |__  _   _ _ __  _ __| | __ _ _ __   __| |      ___| | _ (_) | |
 | '_ \| | | | '_ \| '__| |/ _` | '_ \ / _` |_____/ __| |/ / | | |
 | | | | |_| | |_) | |  | | (_| | | | | (_| |_____\__ \   <| | | |
 |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|     |___/_|\_\_|_|_|
        |___/|_|                                                   
       Autonomous AI Developer Skill for Hyprland & Quickshell
EOF
echo -e "${RESET}"

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
echo -e "${BLUE}==>${RESET} ${BOLD}Ensuring executable permissions on helper scripts...${RESET}"
chmod +x "$INSTALL_DIR"/scripts/* 2>/dev/null || true

# 3. Detect and link into agent harnesses
echo -e "${BLUE}==>${RESET} ${BOLD}Configuring agent discovery symlinks...${RESET}"

link_skill() {
    local target_dir="$1"
    local name="$2"
    mkdir -p "$target_dir"
    ln -sfn "$INSTALL_DIR" "$target_dir/$name"
    echo -e "  ${GREEN}✓${RESET} Linked for ${BOLD}$name${RESET} in ${target_dir}"
}

# Antigravity / Gemini CLI (Global)
link_skill "${HOME}/.gemini/config/skills" "hyprland-skill"

# Standard agent harnesses (~/.agents/skills)
link_skill "${HOME}/.agents/skills" "hyprland-skill"

# Claude Code
link_skill "${HOME}/.claude/skills" "hyprland-skill"

# Workspace level if rhythmcreative/hyprland exists
if [ -d "${HOME}/hyprland" ]; then
    link_skill "${HOME}/hyprland/.agents/skills" "hyprland-skill"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Installation completed successfully!${RESET}"
echo -e "Agents will now automatically load ${CYAN}hyprland-skill${RESET} when working on your desktop."
echo ""
echo -e "Available helper commands:"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/sync-status${RESET}      - Verify file sync between repo and system"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/reload-desktop${RESET}    - Safely reload Hyprland, Quickshell, and Hypridle"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/capture-ui bar${RESET}    - Verify UI layout with instant grim capture"
echo -e "  ${BOLD}${INSTALL_DIR}/scripts/test-battery${RESET}      - Inspect battery sensors and AC state"
echo ""
