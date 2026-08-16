#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Directories that live under ~/.config
CONFIG_DIRS=(ghostty omniwm nvim yazi karabiner zed jjui jj)

link() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.pre-dotfiles-$STAMP"
    echo "backup  $dst.pre-dotfiles-$STAMP"
  fi

  ln -s "$src" "$dst"
  echo "link    $dst"
}

mkdir -p "$CONFIG"

for d in "${CONFIG_DIRS[@]}"; do
  [ -d "$REPO/$d" ] && link "$REPO/$d" "$CONFIG/$d"
done

for f in "$REPO"/home/.*; do
  [ -f "$f" ] || continue
  link "$f" "$HOME/$(basename "$f")"
done

cat <<'EOF'

Done.

Secrets are not in this repo. Recreate them locally if you need them:
  ~/.config/secrets.env              sourced by .zshrc (GITHUB_TOKEN etc.)
  ~/.contentstack-dev23-creds.env    sourced by .zshrc, non-prod QA creds

Then: brew bundle --file=Brewfile, restart the shell, restart Ghostty.
EOF
