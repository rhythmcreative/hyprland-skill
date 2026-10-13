# Arch Linux Installer & OTA Updates Guide (`arch-installer-and-ota.md`)

This guide explains the Arch Linux native installation pipeline (`install.sh`), system migrations, and Over-The-Air (OTA) atomic updates.

---

## The Arch Installer (`install.sh`)

`install.sh` is an automated setup script (over 6,000 lines) responsible for transforming a vanilla Arch Linux installation into the Rhythm desktop environment.

### Execution Phases
1. **System & Hardware Detection**: Detects CPU vendor (Intel/AMD), GPU configuration (NVIDIA, AMD, Intel, or Hybrid Optimus), and display monitors.
2. **Package Management**:
   - Native packages installed via `pacman` (listed in `packages.txt`).
   - AUR packages installed via `yay` (Hyprland plugins, quickshell, pywal, fonts).
   - Isolated sandboxed applications installed via `flatpak` (listed in `flatpaks.txt`).
3. **Dotfiles & Assets Deployment**: Copies configurations to `~/.config/` and scripts to `~/.local/bin/`.
4. **Services Activation**: Enables user systemd daemons for Bluetooth, PipeWire, Quickshell, and power management.
5. **SDDM Astronaut Installation**: Deploys the login theme and Wayland greeter wrapper.

---

## System Migrations (`migrations/`)

When updating an existing installation to a new version, migration scripts in `migrations/` handle state transitions:

* **`001-state-dirs.sh`**: Relocates mutable files (such as battery thresholds and wallpaper caches) from `~/.config/rhythm` to `~/.local/state/rhythm/` so updates never overwrite user settings.
* **`002-version-file.sh`**: Initializes the `.version` file for tracking applied update checkpoints.
* **`003-user-services.sh`**: Enables and restarts newly introduced user systemd services cleanly.

---

## OTA Atomic Update System

The OTA engine allows pushing desktop updates safely with rollback support on Btrfs systems:

* **`ota-updater` (`~/.local/bin/ota-updater`)**: Fetches updates from GitHub `main`, runs pending migrations, and restarts desktop daemons.
* **`ota-snapshot` (`~/.local/bin/ota-snapshot`)**: Takes a read-only Btrfs snapshot before applying changes so the user can roll back if an update fails.
* **`system-ota` (`~/.local/bin/system-ota`)**: User-facing entrypoint displaying update logs and upgrade progress.
