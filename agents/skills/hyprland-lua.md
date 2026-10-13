# Hyprland 0.56 Lua Configuration Guide (`hyprland-lua.md`)

This guide details configuring and scripting **Hyprland 0.56** using its modern **Lua engine** (`~/.config/hypr/hyprland.lua`).

---

## 📜 Lua Engine Basics

Hyprland 0.56 introduces native Lua configuration via the global table `hl`:

* **`hl.config({ ... })`**: Defines configuration blocks (e.g. `general`, `decoration`, `animations`, `misc`, `input`).
* **`hl.bind(combo, action)`**: Binds keys to compositor actions.
* **`hl.dsp.<dispatcher>(args)`**: Creates dispatchers inside Lua.
* **`hl.exec_cmd(cmd)`**: Runs background shell commands.

### Example: Core Configuration Block

```lua
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = "0x111319",
        vrr = 1,
        enable_swallow = true,
        focus_on_activate = true,
        layers_hog_keyboard_focus = false,
        -- CRITICAL: Allow keyboard and mouse activity to wake displays from DPMS off
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },
})
```

---

## ⚠️ The Hyprland 0.56 Dispatcher Trap

In Hyprland 0.56, running standard Hyprland legacy commands via CLI like:
```bash
hyprctl dispatch dpms on   # ❌ FAILS with: "')' expected near 'on'"
```
will fail because `hyprctl` wraps CLI arguments inside `hl.dispatch(...)`, expecting valid Lua expressions.

### The Correct Ways to Dispatch Commands

#### Method 1: Using `hyprctl repl` (Recommended for scripts)
```bash
# Turn DPMS on for a specific monitor
hyprctl repl "hl.dispatch(hl.dsp.dpms('on', 'DP-6'))"

# Turn DPMS on globally for all monitors
hyprctl repl "hl.dispatch(hl.dsp.dpms('on'))"
```

#### Method 2: Passing Quoted Lua to `hyprctl dispatch`
```bash
hyprctl dispatch "hl.dsp.dpms('on')"
```

---

## 🖥️ Multi-Monitor Handling

Query connected monitors dynamically using JSON output:

```bash
# List all active monitor names
monitors=$(hyprctl monitors -j | jq -r '.[] | select(.disabled == false) | .name')

# Check current focused monitor
focused_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
```

---

## 🔄 Reloading Hyprland

To reload configuration changes without restarting the compositor:

```bash
WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 hyprctl reload
```

This updates `hyprland.lua` rules, animations, keybindings, and decorations live.
