# Rust Dock & Application Launchers Guide (`rust-dock.md`)

This guide covers the native Wayland dock written in Rust and the Rofi application menu suites.

---

## Rust Dock (`packages/rust-dock/`)

The repository includes a custom, lightweight Wayland application dock written in **Rust**:

* **Packaging**: Built via Cargo or packaged as a Nix derivation in `packages/rust-dock/default.nix`.
* **Execution**: Launched through `start-dock` and monitored by `rust-dock-monitor-watcher`.
* **Pinned Applications**: Stored in `~/.local/share/rust-dock/pinned` as desktop entry names.
* **Toggling**: Can be toggled on demand or hidden automatically when full-screen windows are focused.

---

## Application Menus & Launchers

### 1. `rofi-themed` (`~/.local/bin/rofi-themed`)
- Launches Rofi with the dynamic Pywal theme.
- Features singleton PID locking: if Rofi is already running, triggering the shortcut closes it instead of spawning duplicate instances.
- Ensures valid UTF-8 locales (`es_ES.UTF-8` / `en_US.UTF-8`) to prevent crashes.

### 2. Specialized Menus
- **`rofi-wifi-menu`**: Interactive network selection menu with live signal strengths and password prompts.
- **`rofi-bluetooth-menu`**: Device scanner, pairer, and audio connection switcher.
- **`powermenu`**: System power controls (Lock, Suspend, Logout, Reboot, Shutdown).
