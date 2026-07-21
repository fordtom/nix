# Pi subagents

Vendored from [`davis7dotsh/my-pi-setup`](https://github.com/davis7dotsh/my-pi-setup/tree/main/extensions/subagents) at commit `797eaf6`.

The runtime source is unchanged. The local package manifest contains only the dependencies needed at runtime.

After stowing this repository on a machine, install the dependencies:

```sh
cd ~/.pi/agent/extensions/subagents
npm install
```

The extension provides Pi, Claude Code, and Codex subagents. The Claude and Codex backends use the corresponding authenticated CLI installations.
