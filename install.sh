#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$REPO/$1" dst="$TARGET/$1"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.pre-dotfiles-$STAMP"
    echo "backup  $dst.pre-dotfiles-$STAMP"
  fi

  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
}

mkdir -p "$TARGET"
link ghostty
link omniwm

echo
echo "Done. Restart Ghostty and reload OmniWM to pick the config up."
