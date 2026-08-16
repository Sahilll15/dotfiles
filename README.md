# dotfiles

My macOS setup: terminal, window manager, shell, editors, and the Homebrew list
that backs it all.

```
ghostty/    Ghostty terminal          nvim/       Neovim (LazyVim)
omniwm/     OmniWM window manager     zed/        Zed
yazi/       Yazi file manager         karabiner/  Karabiner-Elements
jj/         Jujutsu                   jjui/       Jujutsu TUI
home/       shell + git + tmux + vim dotfiles
Brewfile    66 formulae, 10 casks, 9 taps
install.sh  symlinks everything into place
```

Directories at the root map to `~/.config/<name>`. Everything in `home/` maps to `~`.

## Install

```bash
git clone https://github.com/Sahilll15/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles && ./install.sh
brew bundle --file=Brewfile
```

`install.sh` symlinks rather than copies, so edits to the live config are edits to
the repo. Anything already at a target path is moved to a timestamped backup first.

## Ghostty

`ghostty/config` is the entry point, everything else is split out so one piece can be
swapped without touching the main file.

| Path | What's in it |
|---|---|
| `config` | Theme, font, padding, window behaviour |
| `themes/` | Catppuccin Mocha, Dracula, Gruvbox, Nord, Tokyo Night |
| `fonts/` | Cascadia Code, Fira Code, Iosevka, JetBrains Mono, Monaspace Neon |
| `presets/` | Whole-look bundles: cozy-coding, cyberpunk-dev, minimal-focus, professional-elegant |
| `keybinds/`, `platform/` | Split per platform (`macos.conf`, `linux.conf`) |
| `shaders/` | Cursor trail and ripple |

The active theme is a custom black-and-orange build on a Gruvbox Dark Hard palette:
near-black `#0d0f10` background, amber `#fe8019` cursor, colorblind-safe. The previous
auto light/dark theme is commented out at the top of `config` if I want it back.

`keybinds/current.conf` and `platform/current.conf` are relative symlinks to
`macos.conf`. On Linux, repoint them:

```bash
ln -sfn linux.conf ghostty/keybinds/current.conf
ln -sfn linux.conf ghostty/platform/current.conf
```

## OmniWM

`omniwm/settings.toml` holds the lot: appearance, borders, gaps, dwindle layout, focus,
gestures, overview, quake terminal, status bar, workspace bar, 28 app rules, the hotkey
map, monitor routing overrides, and named workspaces with monitor assignments.

`omniwm/hooks/on-display-changed.sh` fires on display change via
`omniwmctl watch display-changed` from a LaunchAgent.

## Shell

`home/.zshrc` is the main one: oh-my-zsh, powerlevel10k (`home/.p10k.zsh`), fzf, zoxide,
and my work aliases. It sources two files that are deliberately **not** in this repo:

| File | Holds |
|---|---|
| `~/.config/secrets.env` | `GITHUB_TOKEN` and friends |
| `~/.contentstack-dev23-creds.env` | non-prod QA credentials |

Both are guarded with `[ -f ... ] &&`, so the shell starts fine without them. Recreate
them by hand on a new machine.

`home/.npmrc` points `@contentstack` at GitHub Packages and reads the token via
`${GITHUB_TOKEN}` interpolation, so no credential is stored in the file.

## Not in this repo

No secrets, no machine state, no backups. Specifically excluded: `~/.config/secrets.env`,
`~/.ssh`, `~/.aws`, `~/.kube`, `~/.docker`, `~/.config/gh`, local certs, shell history,
zcompdump caches, and every `*.bak*` file.
