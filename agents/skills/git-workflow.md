# Git & Release Workflow Guide (`git-workflow.md`)

This guide establishes the mandatory version control and deployment standards for the **rhythmcreative/hyprland** repository.

---

## Golden Standards

1. **Target Branch**: Strictly **`main`**. Never push to `dev` unless explicitly requested.
2. **Commit Language**: Strictly **English**.
3. **Commit Style**: Short, natural, direct, and imperative. Do **not** use Conventional Commits prefixes (avoid `feat:`, `fix:`, `chore:`).
   - [OK] `adjust multi-battery format and power supply icon in quickshell bar`
   - [OK] `fix hyprlock screen disappearance and idle sleep configuration`
   - [OK] `remove obsolete language subview from dynamic island`
   - [FAIL] `fix(battery): arreglar las baterias`

---

## Directory Mapping & Dual-Path Sync

The git working tree resides in `/home/rhythmcreative/hyprland`. The operating system executes configurations from active home directories.

| Repository Source Path | Live System Active Path |
| :--- | :--- |
| `hyprland/.config/quickshell/waybar-island/` | `~/.config/quickshell/waybar-island/` |
| `hyprland/.config/hypr/` | `~/.config/hypr/` |
| `hyprland/.local/bin/` | `~/.local/bin/` |

### Synchronization Checklist Before Every Commit

1. **Sync modified repo files to the system**:
   ```bash
   cp -u ~/hyprland/.config/quickshell/waybar-island/* ~/.config/quickshell/waybar-island/
   cp -u ~/hyprland/.config/hypr/* ~/.config/hypr/
   cp -u ~/hyprland/.local/bin/* ~/.local/bin/
   ```
2. **Check for uncommitted changes**:
   ```bash
   git -C ~/hyprland status
   ```
3. **Inspect the git diff**:
   ```bash
   git -C ~/hyprland diff
   ```
4. **Stage, commit and push**:
   ```bash
   git -C ~/hyprland add <modified_files>
   git -C ~/hyprland commit -m "concise description in english"
   git -C ~/hyprland push origin main
   ```
