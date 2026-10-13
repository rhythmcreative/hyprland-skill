# Idle, Screen Lock & Power Management Guide (`idle-and-power.md`)

This guide outlines the timeout staging, screen lock mechanisms, and battery management architecture in the desktop environment.

---

## ⏱️ Idle & Timeout Lifecycle (`hypridle.conf`)

The idle daemon (`hypridle`) coordinates screen dimming, locking, display sleep, and system suspension.

### Proper Staging Contract

```ini
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session || pidof hyprlock || hyprlock
    after_sleep_cmd = ~/.local/bin/screen-power on
}

# Stage 1: Lock the session at 5 minutes
listener {
    timeout = 300
    on-timeout = loginctl lock-session || pidof hyprlock || hyprlock
}

# Stage 2: Turn off displays 1 minute after locking (6 minutes total)
listener {
    timeout = 360
    on-timeout = ~/.local/bin/screen-power off
    on-resume = ~/.local/bin/screen-power on
}

# Stage 3: Deep system suspend after 30 minutes of total inactivity
listener {
    timeout = 1800
    on-timeout = systemctl suspend
}
```

### Critical Rules for `hypridle`
1. **Never use `on-timeout = lock`**: `lock` is not a built-in shell binary. Always invoke `loginctl lock-session` or `pidof hyprlock || hyprlock`.
2. **Never suspend immediately after lock**: A minimum buffer (e.g. 15-25 minutes) must exist between locking and suspending. Suspending too soon causes the lock screen to flash for 1 second before screens go black.

---

## 🔒 Lock Screen Configuration (`hyprlock.conf`)

`hyprlock` provides a Wayland-native lock screen.

### Essential Flags

* **`immediate_render = true`**: Forces instant widget painting. Prevents the screen from hanging black while heavy wallpaper screenshots are blurred.
* **`fade_on_empty = false`**: Keeps the password input field permanently visible. Setting this to `true` with short timeouts makes the input box vanish, confusing the user into thinking the display has powered off.

---

## 🔋 Battery Information & Thresholds

Power state is extracted via `/sys/class/power_supply/`:

### 1. `battery-info` (`~/.local/bin/battery-info`)
Outputs unified JSON detailing AC state and an array of internal batteries:
```json
{
  "count": 1,
  "devices": [{
    "name": "BAT0",
    "status": "Not charging",
    "capacity": 85,
    "health": 67,
    "voltage": 16.06,
    "threshold": 80,
    "icon": "󰂄"
  }],
  "ac": { "present": true, "online": true },
  "is_charging": false,
  "total_pct": 85
}
```
- **Device Scope Filtering**: Always ignore peripheral power supplies (`scope: Device` such as bluetooth mice or wireless headsets).

### 2. `battery-charge-limit` (`~/.local/bin/battery-charge-limit`)
Applies charging limit thresholds (70%, 80%, 90%, 100%/Off) to prolong battery longevity:
```bash
# Set 80% charge limit across all internal batteries
battery-charge-limit 80

# Set 80% charge limit specifically on BAT1
battery-charge-limit 80 BAT1

# Remove limit (100% full capacity)
battery-charge-limit 100
```
Thresholds are written to `/sys/class/power_supply/BAT*/charge_control_end_threshold` and persisted across reboots via `~/.local/state/rhythm/battery-limit.conf`.
