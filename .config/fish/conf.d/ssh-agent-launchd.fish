if not set -q SSH_AUTH_SOCK; and command -q launchctl
    set -l ssh_auth_sock (launchctl print gui/(id -u)/com.openssh.ssh-agent 2>/dev/null | awk -F'=> ' '/SSH_AUTH_SOCK =>/ { print $2; exit }')
    if test -n "$ssh_auth_sock"; and test -S "$ssh_auth_sock"
        set -gx SSH_AUTH_SOCK "$ssh_auth_sock"
    end
end
