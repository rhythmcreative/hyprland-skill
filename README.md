# 🚀 Hyprland Desktop Ecosystem Skill (`hyprland-skill`)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Hyprland 0.56](https://img.shields.io/badge/Hyprland-0.56%20Lua-blueviolet)](https://hyprland.org/)
[![Quickshell](https://img.shields.io/badge/Quickshell-Desktop%20Suite-00b4d8)](https://git.outfoxxed.me/outfoxxed/quickshell)
[![Platform: Wayland](https://img.shields.io/badge/Platform-Wayland%20Linux-orange)]()

An expert AI coding agent skill and developer manual for the **[rhythmcreative/hyprland](https://github.com/rhythmcreative/hyprland)** desktop environment. Structured after the **Omarchy** agent architecture, this repository provides domain-specific knowledge, modular guides, validation suites, and automation tools for AI pair programmers and human developers.

---

## 📖 What is this Skill?

When an AI coding assistant (such as **Google Antigravity**, **Claude Code**, **OpenCode**, or **Codex**) joins the project, this skill provides instant context on:

* **Hyprland 0.56 (Lua Engine)**: Native Lua scripting (`hl.config`, `hl.bind`), dispatchers (`hl.dispatch(hl.dsp...)`), and multi-monitor topologies.
* **Quickshell Desktop Suite**: Declarative status bar (`BarraWaybar.qml`) and interactive Dynamic Island (`shell.qml`) with IPC control.
* **Power & Idle Management**: Single & dual battery detection, charging thresholds (`battery-charge-limit`), and timeout staging in `hypridle` and `hyprlock`.
* **Pywal Theming**: Live dynamic color synchronization across GTK, Rofi, Quickshell, SDDM, and terminal palettes.
* **Workflow Automation**: Automated visual regression testing via `grim` and strict English git commit protocols on `main`.

---

## 📦 Installation & Setup

### 1. For Antigravity / Gemini CLI Agents
Clone or symlink this repository into your user customization directory:

```bash
# Workspace level
mkdir -p ~/hyprland/.agents/skills
ln -s ~/hyprland-skill ~/hyprland/.agents/skills/hyprland-skill

# Or machine-wide global level
mkdir -p ~/.gemini/config/skills
ln -s ~/hyprland-skill ~/.gemini/config/skills/hyprland-skill
```

### 2. For Claude Code, OpenCode & Codex Agents
```bash
# Claude Code
mkdir -p ~/.claude/skills
ln -s ~/hyprland-skill ~/.claude/skills/hyprland-skill

# Standard .agents path
mkdir -p ~/.agents/skills
ln -s ~/hyprland-skill ~/.agents/skills/hyprland-skill
```

### 3. Via Agent Skills Package Manager
```bash
npx skills add rhythmcreative/hyprland-skill
```

---

## 📂 Repository Structure

```text
hyprland-skill/
├── SKILL.md                          # Primary agent entrypoint and YAML contract
├── README.md                         # Project documentation and quickstart
├── package.json                      # NPM / skills package metadata
├── LICENSE                           # MIT License
│
├── agents/skills/                    # Modular domain guides
│   ├── shell-dev.md                  # Quickshell architecture (BarraWaybar & shell.qml)
│   ├── hyprland-lua.md               # Hyprland 0.56 Lua dispatchers & keybindings
│   ├── idle-and-power.md             # hypridle, hyprlock, DPMS & battery charge limits
│   ├── visual-verification.md        # Headless grim screenshot verification protocols
│   ├── git-workflow.md               # Git standards: 'main' branch & English commits
│   ├── system-scripts.md             # Standards for ~/.local/bin helpers & JSON output
│   ├── nixos-and-flakes.md           # Declarative NixOS Flake & Home Manager architecture
│   ├── arch-installer-and-ota.md     # Arch installer (install.sh), migrations & Btrfs OTA updates
│   ├── sddm-and-theming.md           # SDDM Astronaut theme & Pywal16 dynamic wallpaper color sync
│   └── rust-dock.md                  # Native Wayland Rust dock & dynamic Rofi menus
│
└── scripts/                          # Executable developer & agent automation
    ├── sync-status                   # Compare & synchronize repo vs active system paths
    ├── reload-desktop                # Live reload Quickshell, Hyprland, and Hypridle
    ├── capture-ui                    # Targeted screenshots of bar or dynamic island
    └── test-battery                  # Diagnostic report for sysfs power supplies
```

---

## 🛡️ The 5 Golden Rules for Developers & Agents

1. **Branch is strictly `main`**: All changes land directly in `main`. Avoid branching into `dev`.
2. **Commit Messages in English**: Write clear, active, concise messages (e.g. `adjust multi-battery format and power supply icon in quickshell bar`).
3. **Dual-Path Sync**: Always synchronize files between the git repo (`~/hyprland/`) and active paths (`~/.config/` & `~/.local/bin/`). Use `./scripts/sync-status --sync`.
4. **Preserve Unicode Glyphs**: Never corrupt or strip multi-byte Nerd Font icons (`󰂄`, `󰚥`, `󰁹`, `▁▂▃▄▅▆▇█`).
5. **Verify Visually**: Test with `./scripts/capture-ui bar` before declaring a task complete.

---

## ⚡ Quick Commands

```bash
# Check synchronization between repository and active system files
./scripts/sync-status

# Synchronize out-of-sync files from repository to system
./scripts/sync-status --sync

# Reload desktop environment components cleanly
./scripts/reload-desktop

# Take a screenshot of the top status bar
./scripts/capture-ui bar /tmp/bar.png

# Diagnose battery sensors and power supply status
./scripts/test-battery
```

---

## 🤝 Contributing & License

Created by **Rhythm Creative**. Licensed under the [MIT License](LICENSE).
Contributions and extensions to the Hyprland and Quickshell agent ecosystem are welcome!
