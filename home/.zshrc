# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh (loaded once) ───────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Consolidated plugin list. zsh-syntax-highlighting stays last.
# Dropped the `z` plugin: zoxide (below) handles smart cd.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting history-substring-search)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k prompt config (the theme itself is loaded by oh-my-zsh above).
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Terminal title: "folder (git branch)" ─────────────────────────────
# Ghostty's titlebar/tab stays pinned while the buffer scrolls, so putting
# the folder + branch there keeps them always visible (the p10k prompt
# scrolls away). The shell owns the title; Ghostty just displays it.
DISABLE_AUTO_TITLE="true"   # stop oh-my-zsh overwriting the title each command

_terminal_title_precmd() {
  local dir="${PWD:t}"
  [[ "$PWD" == "$HOME" ]] && dir="~"
  local branch
  branch="$(command git branch --show-current 2>/dev/null)"
  # detached HEAD (e.g. during rebase): fall back to the short commit hash
  [[ -z "$branch" ]] && command git rev-parse --git-dir &>/dev/null \
    && branch="$(command git rev-parse --short HEAD 2>/dev/null)"
  if [[ -n "$branch" ]]; then
    printf '\e]0;%s (%s)\a' "$dir" "$branch"
  else
    printf '\e]0;%s\a' "$dir"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _terminal_title_precmd

# ── PATH (each entry once) ────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME=/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/Users/sahil.chalke/.antigravity/antigravity/bin:$PATH"
export PATH="/Users/sahil.chalke/.antigravity-ide/antigravity-ide/bin:$PATH"
export PATH="/Users/sahil.chalke/.opencode/bin:$PATH"

# ── Integrations ──────────────────────────────────────────────────────
eval "$(zoxide init zsh)"                  # smart cd: `z <dir>` jumps, `zi` interactive
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh     # fzf: Ctrl-R history, Ctrl-T files, Alt-C cd

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                    # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads nvm completion

# ── Knowledge base (Obsidian vault) ───────────────────────────────────
VAULT=/Users/sahil.chalke/Documents/Obsidian\ Vault
alias kb-compile='cd $VAULT && cursor agent "compile — ingest any new files in raw/ into the wiki"'
alias kb-session='cd $VAULT && cursor agent "kb-session — start a new dev session log"'
kb-session-git() {
  cd $VAULT && cursor agent "kb-session-git $1 — auto generate a session log from git history at $1"
}
alias kb-ask='cd $VAULT && cursor agent'
alias kb-lint='cd $VAULT && cursor agent "kb-lint — run a health check on the wiki"'
kb-search() {
  python3 $VAULT/tools/vault-search.py "$1"
}
alias kb-status='cd $VAULT && cursor agent "how many files are in raw/ vs processed in wiki/_summaries.md? List what is new and uncompiled."'

# ── Aliases: git / gh ─────────────────────────────────────────────────
alias gs="git status"
alias ga="git add ."/
alias gaa="git add -"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gco="git checkout"
alias gra="git restore ."
alias gb="git branch"
alias gcb="git checkout -b"
alias gd="git diff"
alias gds="git diff --staged"
alias gp="git push -u origin head"
alias gpf="git push --force"
alias gpl="git pull"
alias gr="git reset"
alias grh="git reset --hard"
alias gst="git stash"
alias gsta="git stash apply"
alias gcl="gh repo clone"
alias ghpr="gh pr create --fill"
alias ghview="gh repo view --web"
alias ghrun="gh run list"
alias ghci="gh issue list"
alias gcp="git cherry-pick"
alias gl="git log --oneline --decorate --graph --all"
alias glp="git log --pretty=format:'%C(yellow)%h%Creset - %Cgreen%an%Creset: %s %Cblue(%cr)%Creset'"
alias ischema='npm install @contentstack/form-fields @contentstack/form-renderer'
alias c.="code ."
alias ghopen="open \$(git config --get remote.origin.url | sed -e 's/git@/https:\/\//' -e 's/com:/com\//' -e 's/.git\$//')"
alias lg='lazygit'
alias jbt='jj bookmark create'
alias jbc='jj bookmark track'
alias jjw='jjui -r "mine() & mutable()"'
alias jjs='jjui -r "trunk()..@"'
alias jja='jjui -r "@ | ancestors(remote_bookmarks().., 2) | trunk()"'

# ── Aliases: npm / yarn / pnpm ────────────────────────────────────────
alias ni="npm install"
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nr="npm run"
alias nrs='npm run start'
alias nrb="npm run build"
alias nrd="npm run dev"
alias nt="npm run test"
alias nrt="npm run test:unit"
alias nu="npm update"
alias npub="npm publish"
alias nc="npm cache clean --force"
alias nrmfe="npm run dev:mfe"
alias nrapp="npm run dev:app"
alias nrst='npm run storybook'
alias ttest="NODE_OPTIONS=\"--max-old-space-size=8192\" npm run test -- --maxWorkers=2"
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias ys="yarn start"
alias yb="yarn build"
alias yt="yarn test"
alias pi="pnpm install"
alias pa="pnpm add"
alias pad="pnpm add -D"
alias prd="pnpm run dev"
alias prb="pnpm run build"

# ── Aliases: Python ───────────────────────────────────────────────────
alias pin='pip3 install'
alias pr='python3'
alias penv='python3 -m venv'
alias pfr='pip3 freeze > requirements.txt'

# ── Aliases: files / terminal utils ───────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias e="code ."
alias serve="npx serve"
alias http="python3 -m http.server"
alias openapi="openapi-generator-cli generate"
alias hist="history | fzf"
alias pipes="pipes.sh"
alias weather="curl wttr.in"
alias matrix="cmatrix"
alias fuck="thefuck"
alias ls="eza -lah --icons --group-directories-first"
alias cat="bat"
alias incsr='cd test-resources/csr'
alias invb="cd /Users/sahil.chalke/Desktop/VB/visual-builder"

# ── Aliases: testing / formatting / search ────────────────────────────
alias lint="npm run lint"
alias fix="npm run lint -- --fix"
alias fmt="npx prettier --write ."
alias test="npm test"
alias todo="rg TODO"
alias fixme="rg FIXME"
alias grepfn="rg 'function '"
alias findjs="fd . --extension js"
alias findts="fd . --extension ts"

# ── Aliases: zsh management ───────────────────────────────────────────
alias zshrc="code ~/.zshrc"
alias aliases="code ~/.zshrc"
alias reload="source ~/.zshrc"
alias updatebrew="brew update && brew upgrade && brew cleanup"

# ── Contentstack dev shortcuts ────────────────────────────────────────
alias dev-start='/Users/sahil.chalke/Desktop/contentstack-code-repos/scripts/dev-start.sh'
alias set-env='/Users/sahil.chalke/Desktop/contentstack-code-repos/scripts/set-env.sh'
alias setup-env-vb='cd /Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem/visual-editor && npm run setup-env'
alias kill-ports='/Users/sahil.chalke/Desktop/contentstack-code-repos/scripts/kill-ports.sh'
alias link-vb='(cd /Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem && npm run link:packages)'
alias unlink-vb='(cd /Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem && npm run unlink:packages)'
alias seed-csr='(cd /Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem/visual-editor && npx tsx tests/setup/dev/seed-csr-app.ts)'
alias e2eui="cd /Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem/visual-editor && npm run test:e2e:csr -- --ui"
alias acl-reset='/Users/sahil.chalke/Desktop/contentstack-code-repos/scripts/acl-reset.sh'
# UI-React host :8081 + Visual Editor remote :3030 + ai-blog :3010 against dev23/dev11
alias stack='/Users/sahil.chalke/.claude/skills/dev-stack-run/dev-stack.sh'
alias stack-up='/Users/sahil.chalke/.claude/skills/dev-stack-run/dev-stack.sh up dev23'
alias stack-status='/Users/sahil.chalke/.claude/skills/dev-stack-run/dev-stack.sh status'
alias stack-down='/Users/sahil.chalke/.claude/skills/dev-stack-run/dev-stack.sh down'
# Named OmniWM workspace for a feature: fws <name> [repo-path]
alias fws='/Users/sahil.chalke/.claude/skills/feature-workspace/feature-workspace.sh'
inUE() { cd "$HOME/Desktop/contentstack-code-repos/UI-React" || return 1; }
inVB() { cd "/Users/sahil.chalke/Desktop/contentstack-code-repos/visual-builder-ecosystem/visual-editor" || return 1; }

# ── FZF navigation shortcuts ──────────────────────────────────────────
# Ctrl-P: pick a zoxide dir with fzf, then cd
function fzf_cd() {
  local dir
  dir=$(zoxide query -l | fzf --height=40% --reverse --preview 'ls -la {}') && cd "$dir"
}
bindkey -s '^P' 'fzf_cd\n'

# Ctrl-O: find a file, then cd to its directory
function fzf_find_file_and_cd() {
  local file
  file=$(fd . --type f | fzf --preview 'bat --style=numbers --color=always {} | head -100') || return
  cd "$(dirname "$file")"
}
bindkey -s '^O' 'fzf_find_file_and_cd\n'

# Ctrl-F: find a file, then open it in VS Code
function fzf_open_file() {
  local file
  file=$(fd . --type f | fzf --preview 'bat --style=numbers --color=always {} | head -100') || return
  code "$file"
}
bindkey -s '^F' 'fzf_open_file\n'

# Yazi: `y` opens yazi and cd's to the folder you were browsing when you quit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ── Claude Code ───────────────────────────────────────────────────────
# `ccfix` reapplies our tweakcc CLI customizations (full-width boxed user
# messages, input border, expanded thinking, "Claude (VS Code)" theme) after a
# Claude Code update wipes the binary patch. Settings persist in
# ~/.tweakcc/config.json; the theme file survives updates on its own.
alias ccfix='npx --yes tweakcc@latest --apply'

# On launch via `C`/`cs`, auto-reapply the tweakcc patch if Claude Code has
# updated since the profile was last applied. tweakcc writes the patched version
# back into ~/.tweakcc/config.json (ccVersion), so once a version is applied this
# is a no-op fast check; the `npx … --apply` only runs on an actual version bump.
_tweakcc_check() {
  local cfg="$HOME/.tweakcc/config.json"
  [ -f "$cfg" ] || return 0
  local installed patched
  installed=$(command claude --version 2>/dev/null | head -1 | awk '{print $1}')
  [ -n "$installed" ] || return 0
  patched=$(python3 -c "import json;print(json.load(open('$cfg')).get('ccVersion',''))" 2>/dev/null)
  if [ "$installed" != "$patched" ]; then
    printf '\033[38;5;208mtweakcc\033[0m: Claude Code updated to %s (profile was for %s). Re-applying…\n' "$installed" "${patched:-none}"
    if npx --yes tweakcc@latest --apply; then
      printf '\033[38;5;208mtweakcc\033[0m: profile re-applied for %s.\n' "$installed"
    else
      printf '\033[38;5;208mtweakcc\033[0m: re-apply failed — run \033[1mccfix\033[0m manually.\n'
    fi
  fi
}

# `C` = launch Claude Code, reminding you to reapply if CC updated.
C() { _tweakcc_check; command claude "$@"; }

# `usage` = Claude usage at a glance, in the terminal (no dashboard, no browser).
# Shows the active 5-hour reset window, then today and this week. Data via
# ccusage reading local ~/.claude logs (offline). `usage day` / `usage week`
# open the full ccusage tables.
usage() {
  command -v ccusage >/dev/null 2>&1 || { echo "ccusage not found — run: npm i -g ccusage"; return 1; }
  case "$1" in
    day|daily)   ccusage daily ;;
    week|weekly) ccusage weekly ;;
    *)
      [ -x "$HOME/.claude/usage-pct.sh" ] && { "$HOME/.claude/usage-pct.sh"; echo; }
      ccusage blocks --active
      echo
      ccusage daily  --json 2>/dev/null | jq -r '.daily[-1]  | "Today (\(.period)):      $\((.totalCost*100|round)/100)  ·  \(.totalTokens/1000000|floor)M tokens"' 2>/dev/null
      ccusage weekly --json 2>/dev/null | jq -r '.weekly[-1] | "This week (\(.period)+):  $\((.totalCost*100|round)/100)  ·  \(.totalTokens/1000000|floor)M tokens"' 2>/dev/null
      ;;
  esac
}

# Claude Code + tmux quick session:
#   cw          attach to (or create) tmux session "work"
#   cw <name>   attach to (or create) a session named <name>
cw() {
  local name="${1:-work}"
  if [ -n "$TMUX" ]; then
    # already inside tmux: create if needed, then jump to it
    tmux has-session -t "$name" 2>/dev/null || tmux new-session -d -s "$name"
    tmux switch-client -t "$name"
  else
    tmux new-session -A -s "$name"
  fi
}
alias cwl='tmux ls'   # list running tmux sessions

# tmux auto-attach on terminal open was removed 2026-07-02: it ran after
# powerlevel10k's instant prompt grabbed the tty, so tmux printed
# "open terminal failed: not a terminal" and tripped p10k's init warning.
# Enter tmux manually with `cw` (or `cs` below). If you ever want auto-attach
# back, it must go ABOVE the instant-prompt block at the very top of this file.

# cs [args…] → tmux session named after the current repo, running Claude Code.
cs() {
  _tweakcc_check
  if [ -n "$TMUX" ]; then claude "$@"; return; fi
  local name="claude-$(basename "$PWD" | sed 's/[^a-zA-Z0-9_-]/-/g')"
  tmux new-session -A -s "$name" -c "$PWD" "claude $*; exec zsh"
}

# Claude: auto PR self-review after an interactive push
[ -f "$HOME/.claude/shell/git-pr-review.zsh" ] && source "$HOME/.claude/shell/git-pr-review.zsh"

# Contentstack dev23 QA creds (non-prod)
[ -f "$HOME/.contentstack-dev23-creds.env" ] && source "$HOME/.contentstack-dev23-creds.env"

# global API keys (chmod 600, never committed)
[ -f "$HOME/.config/secrets.env" ] && source "$HOME/.config/secrets.env"

# Pilot Shell
export PATH="$HOME/.pilot/bin:$HOME/.bun/bin:$PATH"
alias pilot="$HOME/.pilot/bin/pilot"
alias ccp="$HOME/.pilot/bin/pilot"
claude() { local _sid="$$-$RANDOM"; PILOT_SESSION_ID=$_sid CLAUDE_CODE_TASK_LIST_ID="pilot-$_sid" command claude "$@"; }
codex() { PILOT_SESSION_ID="$$-$RANDOM" command codex "$@"; }
