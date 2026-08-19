# Make the macOS launchd ssh-agent visible to fish and restore Keychain-backed identities.
if command -q launchctl
    set -l ssh_auth_sock (launchctl print gui/(id -u)/com.openssh.ssh-agent 2>/dev/null | awk -F'=> ' '/SSH_AUTH_SOCK =>/ { print $2; exit }')
    if test -n "$ssh_auth_sock"; and test -S "$ssh_auth_sock"
        if not set -q SSH_AUTH_SOCK
            set -gx SSH_AUTH_SOCK "$ssh_auth_sock"
        end
        if test "$SSH_AUTH_SOCK" = "$ssh_auth_sock"; and command -q ssh-add
            command ssh-add --apple-load-keychain >/dev/null 2>&1
        end
    end
end
