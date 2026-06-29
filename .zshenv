# Make the macOS launchd ssh-agent visible to noninteractive SSH-launched zsh.
if [[ -z "${SSH_AUTH_SOCK:-}" ]] && command -v launchctl >/dev/null 2>&1; then
  _ssh_auth_sock="$(launchctl print "gui/$(id -u)/com.openssh.ssh-agent" 2>/dev/null | awk -F'=> ' '/SSH_AUTH_SOCK =>/ { print $2; exit }')"
  if [[ -n "${_ssh_auth_sock}" && -S "${_ssh_auth_sock}" ]]; then
    export SSH_AUTH_SOCK="${_ssh_auth_sock}"
  fi
  unset _ssh_auth_sock
fi
