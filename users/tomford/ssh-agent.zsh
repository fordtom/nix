# Make the macOS launchd ssh-agent visible to zsh and restore Keychain-backed identities.
if command -v launchctl >/dev/null 2>&1; then
  _ssh_auth_sock="$(launchctl print "gui/$(id -u)/com.openssh.ssh-agent" 2>/dev/null | awk -F'=> ' '/SSH_AUTH_SOCK =>/ { print $2; exit }')"
  if [[ -n "${_ssh_auth_sock}" && -S "${_ssh_auth_sock}" ]]; then
    if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
      export SSH_AUTH_SOCK="${_ssh_auth_sock}"
    fi
    if [[ "${SSH_AUTH_SOCK}" == "${_ssh_auth_sock}" ]] && command -v ssh-add >/dev/null 2>&1; then
      ssh-add --apple-load-keychain >/dev/null 2>&1
    fi
  fi
  unset _ssh_auth_sock
fi
