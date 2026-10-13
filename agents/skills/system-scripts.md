# System Scripts & Helpers Guide (`system-scripts.md`)

This guide covers the standards and patterns for creating and maintaining helper scripts in `~/.local/bin/`.

---

## 🛠️ Script Conventions

### 1. Shebang & Robust Shell Options
All Bash utilities must begin with strict mode:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

### 2. Wayland Environment Initialization
Scripts interacting with Wayland, Hyprland, or Quickshell must ensure valid session variables:
```bash
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
if [ -z "${WAYLAND_DISPLAY:-}" ]; then
    _wl=$(ls -t "$XDG_RUNTIME_DIR"/wayland-[0-9]* 2>/dev/null | grep -v '\.lock$' | head -n1)
    if [ -n "$_wl" ]; then export WAYLAND_DISPLAY=$(basename "$_wl"); fi
    unset _wl
fi
```

### 3. JSON Output Contracts
Helpers consumed by Quickshell processes (`Process {}` / `StdioCollector`) should produce single-line JSON on standard output:
- Ensure numeric values are numbers, not strings.
- Gracefully output empty/fallback objects on hardware absence:
  ```json
  {"count": 0, "devices": [], "ac": {"present": false, "online": false}}
  ```
- Always test helpers directly in terminal before binding to QML:
  ```bash
  ~/.local/bin/battery-info | jq .
  ```

---

## 📋 Catalog of Core Helpers

| Script | Purpose |
| :--- | :--- |
| `battery-info` | Returns complete multi-battery sysfs state in JSON for Quickshell. |
| `battery-charge-limit` | Writes battery charge end thresholds and persists them across reboots. |
| `screen-power` | Toggles or turns on/off displays via Hyprland Lua DPMS dispatchers. |
| `rofi-themed` | Wrapper launching Rofi with dynamic Pywal colors and singleton PID locking. |
| `notch-hypr-helper` | Dispatches Hyprland workspace, layout, and performance mode toggles. |
| `modern-pywal-sync` | Extracts color palettes from current wallpapers and updates all desktop skins. |
