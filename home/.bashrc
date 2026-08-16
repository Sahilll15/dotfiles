[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.local/bin:$PATH"

# Pilot Shell
export PATH="$HOME/.pilot/bin:$HOME/.bun/bin:$PATH"
alias pilot="$HOME/.pilot/bin/pilot"
alias ccp="$HOME/.pilot/bin/pilot"
claude() { local _sid="$$-$RANDOM"; PILOT_SESSION_ID=$_sid CLAUDE_CODE_TASK_LIST_ID="pilot-$_sid" command claude "$@"; }
codex() { PILOT_SESSION_ID="$$-$RANDOM" command codex "$@"; }
