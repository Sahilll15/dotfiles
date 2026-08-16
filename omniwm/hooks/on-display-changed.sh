#!/bin/zsh
# Fired by `omniwmctl watch display-changed` (see the com.sahil.omniwm.displaywatch LaunchAgent).
# Runs once per display topology change (monitor plugged in / unplugged / rearranged).
# Kept deliberately conservative: log the new topology, then best-effort rescue any
# windows left stranded off-screen when a display goes away. OmniWM auto-migrates
# workspaces on its own; the rescue is a safety net, and "not_found" means nothing needed it.

CTL="/Applications/OmniWM.app/Contents/MacOS/omniwmctl"
LOG="$HOME/.local/state/omniwm/display-hook.log"
ts="$(date '+%Y-%m-%d %H:%M:%S')"

# Do NOT read stdin (watch passes event data as args; reading stdin could block).
displays="$("$CTL" query displays --fields name,is-main,active-workspace --format tsv 2>/dev/null | tr '\n' ';')"
print -r -- "[$ts] display-changed | args:[$*] | displays: ${displays}" >> "$LOG"

rescue_out="$("$CTL" command rescue-offscreen-windows 2>&1)"
if [[ "$rescue_out" == *not_found* ]]; then
  print -r -- "[$ts]   rescue: nothing to rescue" >> "$LOG"
else
  print -r -- "[$ts]   rescue: ${rescue_out:-ok}" >> "$LOG"
fi
