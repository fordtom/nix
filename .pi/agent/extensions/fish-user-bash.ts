import {
  createLocalBashOperations,
  type ExtensionAPI,
} from "@mariozechner/pi-coding-agent";

function shellQuote(value: string) {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

function getFishCommand() {
  return process.env.PI_USER_BASH_SHELL || "fish";
}

function getFishFlags() {
  return process.env.PI_USER_BASH_FISH_FLAGS || "-lic";
}

export default function (pi: ExtensionAPI) {
  const local = createLocalBashOperations();

  pi.on("user_bash", () => {
    return {
      operations: {
        exec(command, cwd, options) {
          const fishCommand = `${shellQuote(getFishCommand())} ${getFishFlags()} ${shellQuote(command)}`;
          const wrappedCommand = [
            "if command -v direnv >/dev/null 2>&1; then",
            `  exec direnv exec ${shellQuote(cwd)} ${fishCommand};`,
            "else",
            `  exec ${fishCommand};`,
            "fi",
          ].join("\n");

          return local.exec(wrappedCommand, cwd, options);
        },
      },
    };
  });
}
