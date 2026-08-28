if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

if [[ -o interactive ]]; then
  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
  fi

  alias cat='bat'
  alias cd='z'
  alias find='fd'
  alias ga='git add'
  alias gc='git commit'
  alias gco='git checkout'
  alias gcp='git cherry-pick'
  alias gcu='git cleanup'
  alias gdiff='git diff'
  alias gl='git prettylog'
  alias gp='git push'
  alias grep='rg'
  alias gs='git status'
  alias la='ls -a'
  alias lg='lazygit'
  alias ll='ls -l'
  alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
  alias v='nvim'

  if command -v starship >/dev/null 2>&1 && [[ "$TERM" != dumb ]]; then
    eval "$(starship init zsh)"
  fi

  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
  fi
fi
