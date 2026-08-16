# dotfiles

My Ghostty terminal and OmniWM window manager config, on macOS.

```
ghostty/     Ghostty terminal
omniwm/      OmniWM tiling window manager
```

## Ghostty

`ghostty/config` is the entry point. Everything else is split out so a piece can be
swapped without touching the main file.

| Path | What's in it |
|---|---|
| `config` | Main config: theme, font, padding, window behaviour |
| `themes/` | Catppuccin Mocha, Dracula, Gruvbox, Nord, Tokyo Night |
| `fonts/` | Cascadia Code, Fira Code, Iosevka, JetBrains Mono, Monaspace Neon |
| `presets/` | Whole-look bundles: cozy-coding, cyberpunk-dev, minimal-focus, professional-elegant |
| `keybinds/` | Keybinds, split per platform (`macos.conf`, `linux.conf`) |
| `platform/` | Platform-specific settings, same split |
| `shaders/` | Cursor shaders: trail and ripple |
| `tmux/` | tmux config that goes with the terminal setup |

The active theme is a custom black-and-orange build on a Gruvbox Dark Hard palette:
near-black `#0d0f10` background, amber `#fe8019` cursor. It's colorblind-safe. The
previous auto light/dark theme is commented out at the top of `config` if I want it back.

`keybinds/current.conf` and `platform/current.conf` are relative symlinks to the
`macos.conf` in the same folder. On Linux, repoint them at `linux.conf`:

```bash
ln -sfn linux.conf ghostty/keybinds/current.conf
ln -sfn linux.conf ghostty/platform/current.conf
```

## OmniWM

`omniwm/settings.toml` is the whole config: appearance, borders, gaps, dwindle layout,
focus, gestures, overview, quake terminal, status bar, and workspace bar. Plus 28 app
rules, the hotkey map, monitor routing overrides, and named workspaces with their
monitor assignments.

`omniwm/hooks/on-display-changed.sh` fires when displays change, driven by
`omniwmctl watch display-changed` via a LaunchAgent.

## Install

```bash
./install.sh
```

It symlinks `ghostty/` to `~/.config/ghostty` and `omniwm/` to `~/.config/omniwm`,
moving anything already there to a timestamped backup first.

## Not in here

Local state and backups are gitignored: OmniWM's `runtime-state.json`, every
`*.bak*` file, and `.DS_Store`.
