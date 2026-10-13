# Visual Verification Guide (`visual-verification.md`)

This guide outlines protocols for verifying graphical UI components in Wayland without disturbing the user's active session.

---

## Capturing Screenshots with `grim`

In Hyprland/Wayland, `grim` captures framebuffers directly from the compositor.

### Environment Requirements
Always pass `WAYLAND_DISPLAY` and `XDG_RUNTIME_DIR`:

```bash
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
```

### Targeted Geometry Syntax
`grim` requires geometry in the format `"X,Y WxH"` (notice the space between coordinates and dimensions, and `x` between width and height).

```bash
# 1. Top Status Bar on Primary Monitor (2560x1440 at 0,0)
grim -g "0,0 2560x40" /tmp/test_bar.png

# 2. Dynamic Island / Control Center Area (centered top)
grim -g "600,0 1360x600" /tmp/test_island.png

# 3. Full Secondary Monitor (eDP-1 at 2560x0, 1920x1080)
grim -g "2560,0 1920x1080" /tmp/test_edp.png
```

---

## Visual Quality Checklist

When reviewing screenshots of modified components, verify:

1. **Alignment & Spacing**:
   - Ensure pills in `BarraWaybar.qml` have consistent padding and do not overflow their rectangles.
   - For desktop power (no battery), ensure the wall plug icon `󰚥` is centered and no trailing text or empty gaps appear.
2. **Text & Unicode Integrity**:
   - Verify that Nerd Font glyphs render as clean icons, not question marks (`?`), empty rectangles, or fallback fonts.
   - For audio visualizer (CAVA), verify that unicode bar characters (`▁▂▃▄▅▆▇█`) render smoothly without mojibake.
3. **Contrast & Theme Palette**:
   - Ensure text color adheres to Pywal contrast colors (`colFg`, `colMuted`, `colAccent`).
   - Check that red/orange warnings trigger properly for critical states (CPU/GPU temperature > 75°C, battery <= 15%).
