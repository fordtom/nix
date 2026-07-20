import {
  createLocalBashOperations,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

function shellQuote(value: string) {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

function getFishCommand() {
  return process.env.PI_USER_BASH_SHELL || "fish";
}

function getFishFlags() {
  return process.env.PI_USER_BASH_FISH_FLAGS || "-lic";
}

function fishCommand(command: string) {
  return `${shellQuote(getFishCommand())} ${getFishFlags()} ${shellQuote(command)}`;
}

export default function (pi: ExtensionAPI) {
  const local = createLocalBashOperations();

  pi.on("user_bash", () => ({
    operations: {
      exec(command, cwd, options) {
        const wrappedCommand = [
          "if command -v direnv >/dev/null 2>&1; then",
          `  exec direnv exec ${shellQuote(cwd)} ${fishCommand(command)};`,
          "else",
          `  exec ${fishCommand(command)};`,
          "fi",
        ].join("\n");

        return local.exec(wrappedCommand, cwd, options);
      },
    },
  }));
}
