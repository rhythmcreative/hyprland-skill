# NixOS & Home Manager Flake Architecture (`nixos-and-flakes.md`)

This guide covers the declarative NixOS and Home Manager implementation of the **rhythmcreative/hyprland** desktop.

---

## Flake Architecture (`flake.nix`)

The repository provides a dual deployment model:
1. An imperative installer for vanilla Arch Linux (`install.sh`).
2. A declarative **NixOS Flake** (`flake.nix`) managing system configurations and user environments through Home Manager.

```text
hyprland/
├── flake.nix                         # Flake inputs (nixpkgs, home-manager) and outputs
├── flake.lock                        # Pinned dependency revisions
├── hosts/asus/configuration.nix     # Host system configuration (ASUS ROG/TUF target)
├── homes/rhythm/home.nix             # Home Manager profile for user 'rhythm'
│
├── modules/
│   ├── nixos/                        # System-level modules (audio, sddm, hardware, hyprland)
│   └── home-manager/                 # User-level modules (dotfiles, themes, services, helpers)
│
├── overlays/                         # Custom nixpkgs overlays
└── packages/                         # Custom Nix derivations
    ├── greeter-monitor/              # Multi-monitor setup for SDDM login screen
    ├── helpers/                      # Wrapped scripts from ~/.local/bin
    ├── patched-dotfiles/             # Dotfile derivations with substituted paths
    ├── pywal-sync-mono/              # Python Pywal synchronization package
    └── rust-dock/                    # Native Rust Wayland dock application
```

---

## Core Nix Modules

### 1. `modules/nixos/`
- **`hyprland.nix`**: Enables Hyprland compositor with UWSM/systemd integration and required Wayland portals (`xdg-desktop-portal-hyprland`).
- **`sddm.nix`**: Deploys the Astronaut theme, installs the Wayland greeter compositor, and invokes `sddm-greeter-monitor`.
- **`audio.nix`**: Configures PipeWire, WirePlumber, and low-latency audio rules.
- **`hardware.nix`**: GPU setup (NVIDIA proprietary or AMD open drivers), power management (`power-profiles-daemon` or `tlp`).

### 2. `modules/home-manager/`
- **`dotfiles.nix`**: Manages declarative symlinking of `~/.config/hypr`, `~/.config/quickshell`, and related dotfiles.
- **`themes.nix`**: Pywal color generation and dynamic theme bridges.
- **`services.nix`**: User systemd units (`quickshell-island.service`, `rhythm-nightlight.timer`, `rhythm-caffeine.service`).

---

## Testing & Building on NixOS

```bash
# Validate flake evaluation without applying
nix flake check

# Build the ASUS host configuration
nixos-rebuild build --flake .#asus

# Build and switch home-manager configuration
home-manager switch --flake .#rhythm
```
