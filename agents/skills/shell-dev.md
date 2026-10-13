# Quickshell Development Guide (`shell-dev.md`)

This guide covers editing and extending the desktop shell implemented in **Quickshell** (`~/.config/quickshell/waybar-island/`).

---

## 🏗️ Architecture

The Quickshell suite consists of two primary QML components loaded simultaneously:

1. **`BarraWaybar.qml`**
   - Top panel anchored to screen edge (`WlrLayershell.Top`).
   - Acts as an ultra-fast Waybar replacement written in declarative QML.
   - Contains:
     - Workspace indicators (filtered per monitor).
     - System resource monitors: CPU bar, RAM usage, CPU temperature, GPU temperature.
     - Live audio CAVA visualizer bars (`cavaBars`).
     - Dynamic Island toggle pill / central clock.
     - Tray items: Keyboard layout pill, Bluetooth status & device name, Network status (WiFi / Ethernet), Backlight percentage, Volume & mute state, Power/Battery pill.

2. **`shell.qml`**
   - The interactive Dynamic Island and Control Center window.
   - Positioned as a floating layer shell near the top-center notch.
   - Architecture:
     - **Collapsed state**: Small pill showing ambient notifications, playing media, or date/time.
     - **Expanded state**: Two primary tabs:
       - **Tab 0 (Quick Controls)**: Sliders for Volume and Brightness, toggles for WiFi, Bluetooth, DND, Caffeine, Night Light, Recording, Power Saver, Performance mode.
       - **Tab 1 (Hyprland / System Settings)**: Detailed device controls organized into modular subviews (`controlSubView` 1 to 7):
         - Subview 1: Audio outputs & application streams.
         - Subview 2: Bluetooth scanner & paired devices.
         - Subview 3: WiFi scanner & network selector.
         - Subview 4: Display & monitor manager (resolutions, scales, positions).
         - Subview 5: Wallpapers & visual theme switcher.
         - Subview 6: Performance profiles & power governors.
         - Subview 7: Battery health, cycles, wattages & charge thresholds.

---

## ⚡ IPC Gateway

Quickshell exposes an IPC interface using `quickshell ipc`. Never manipulate internal sockets directly; use the IPC helper commands:

```bash
# Toggle the Dynamic Island on a specific monitor (e.g. DP-6 or eDP-1)
quickshell ipc -p $HOME/.config/quickshell/waybar-island/shell.qml --any-display call island toggleIsland "DP-6"

# Toggle directly into the Battery subview (subview 7)
quickshell ipc -p $HOME/.config/quickshell/waybar-island/shell.qml --any-display call island toggleBattery "DP-6"

# Toggle into the System Monitor / Quick Controls
quickshell ipc -p $HOME/.config/quickshell/waybar-island/shell.qml --any-display call island toggleSysMon "DP-6"

# Toggle Bluetooth or WiFi subviews
quickshell ipc -p $HOME/.config/quickshell/waybar-island/shell.qml --any-display call island toggleBluetooth "DP-6"
quickshell ipc -p $HOME/.config/quickshell/waybar-island/shell.qml --any-display call island toggleWifi "DP-6"
```

---

## 🔋 Battery Formatting Standards

### Top Bar Widget (`BarraWaybar.qml`)

```qml
// Icon logic
if (!barWin.hasBattery || batCount === 0 || bStatus === "AC") {
    barWin.batIcon = "󰚥"  // Wall plug icon for desktop PC without battery
} else if (barWin.batCharging || barWin.batPlugged) {
    barWin.batIcon = "󰂄"  // Charging lightning icon when plugged with battery
} else {
    // Dynamic level icon from 󰁹 (100%) down to 󰁺 (10%)
}
```

- **Desktop (No battery)**:
  - Display **only** the wall plug icon `󰚥`.
  - The percentage text **must be hidden** (`visible: barWin.hasBattery`). Never display fake text like `"CA"` or `"100%"`.
- **Single Battery**:
  - Display `{icon} {capacity}%` (e.g., `󰂄 85%` while plugged, or `󰁹 85%` on battery).
- **Dual Battery (ThinkPad T480 / Multi-battery)**:
  - Display `{icon} {BAT0}% │ {BAT1}%` (e.g., `󰂄 80% │ 90%`).
  - Use box drawing character `│` (U+2502) as the separator for a clean look identical to Waybar.

---

## 🔄 Live Reloading Procedure

Whenever you update `BarraWaybar.qml` or `shell.qml`:

1. Copy the modified file from the repository to `~/.config/quickshell/waybar-island/`.
2. Perform a clean restart of the Quickshell process:
   ```bash
   killall quickshell 2>/dev/null || true
   sleep 0.5
   WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 quickshell -p ~/.config/quickshell/waybar-island/shell.qml >/tmp/quickshell.log 2>&1 &
   sleep 1.5
   ```
3. Inspect `/tmp/quickshell.log` to ensure no QML syntax or type errors occurred (`Configuration Loaded`).
4. Take a screenshot with `grim` to verify visual rendering.
