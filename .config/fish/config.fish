if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

if test -x "$HOME/.local/bin/mise"
    "$HOME/.local/bin/mise" activate fish | source
end

set -g fish_greeting

if status is-interactive
    alias cat bat
    alias cd z
    alias find fd
    alias ga 'git add'
    alias gc 'git commit'
    alias gco 'git checkout'
    alias gcp 'git cherry-pick'
    alias gcu 'git cleanup'
    alias gdiff 'git diff'
    alias gl 'git prettylog'
    alias gp 'git push'
    alias grep rg
    alias gs 'git status'
    alias lg lazygit
    alias la 'ls -a'
    alias ll 'ls -l'
    alias tailscale /Applications/Tailscale.app/Contents/MacOS/Tailscale
    alias v nvim

    command -q atuin; and atuin init fish | source
    command -q zoxide; and zoxide init fish | source

    if test "$TERM" != dumb; and command -q starship
        starship init fish | source
    end
end
