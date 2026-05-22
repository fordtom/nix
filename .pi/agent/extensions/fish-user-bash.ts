import { spawnSync } from "node:child_process";
import {
  createLocalBashOperations,
  type ExtensionAPI,
} from "@mariozechner/pi-coding-agent";

const TUI_COMMANDS: Record<string, string> = {
  "tui:diff": "hunk diff",
  "tui:git": "lazygit",
  "tui:v": `${process.env.EDITOR || "nvim"} .`,
};

const INTERACTIVE_PREFIXES = [
  "hunk",
  "lazygit",
  "nvim",
  "vim",
  "vi",
];

function shellQuote(value: string) {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

function getFishCommand() {
  return process.env.PI_USER_BASH_SHELL || "fish";
}

function getFishFlags() {
  return process.env.PI_USER_BASH_FISH_FLAGS || "-lic";
}

function fishArgs(command: string) {
  return [...getFishFlags().split(/\s+/).filter(Boolean), command];
}

function fishCommandString(command: string) {
  return `${shellQuote(getFishCommand())} ${getFishFlags()} ${shellQuote(command)}`;
}

function isInteractiveCommand(command: string) {
  const trimmed = command.trim().toLowerCase();
  return INTERACTIVE_PREFIXES.some(
    (prefix) => trimmed === prefix || trimmed.startsWith(`${prefix} `),
  );
}

async function runInteractive(ctx: Parameters<ExtensionAPI["registerCommand"]>[1] extends { handler: infer H } ? H extends (args: string, ctx: infer C) => unknown ? C : never : never, command: string) {
  if (!ctx.hasUI) {
    ctx.ui.notify("Interactive TUI commands require Pi interactive mode", "error");
    return 1;
  }

  return await ctx.ui.custom<number | null>((tui, _theme, _kb, done) => {
    tui.stop();
    process.stdout.write("\x1b[2J\x1b[H");

    const result = spawnSync(getFishCommand(), fishArgs(command), {
      cwd: ctx.cwd,
      stdio: "inherit",
      env: process.env,
    });

    tui.start();
    tui.requestRender(true);
    done(result.status ?? 1);

    return { render: () => [], invalidate: () => {} };
  });
}

export default function (pi: ExtensionAPI) {
  const local = createLocalBashOperations();

  for (const [name, command] of Object.entries(TUI_COMMANDS)) {
    pi.registerCommand(name, {
      description: `Run ${command} as a terminal TUI`,
      handler: async (_args, ctx) => {
        await ctx.waitForIdle();
        const exitCode = await runInteractive(ctx, command);
        if (exitCode && exitCode !== 0) {
          ctx.ui.notify(`${command} exited with code ${exitCode}`, "warning");
        }
      },
    });
  }

  pi.on("user_bash", async (event, ctx) => {
    let command = event.command.trim();
    let forceInteractive = false;

    if (command.startsWith("i ") || command.startsWith("i\t")) {
      forceInteractive = true;
      command = command.slice(2).trim();
    }

    if (forceInteractive || isInteractiveCommand(command)) {
      const exitCode = await runInteractive(ctx, command);
      return {
        result: {
          output:
            exitCode === 0
              ? "(interactive command completed successfully)"
              : `(interactive command exited with code ${exitCode ?? 1})`,
          exitCode: exitCode ?? 1,
          cancelled: false,
          truncated: false,
        },
      };
    }

    return {
      operations: {
        exec(command, cwd, options) {
          const wrappedCommand = [
            "if command -v direnv >/dev/null 2>&1; then",
            `  exec direnv exec ${shellQuote(cwd)} ${fishCommandString(command)};`,
            "else",
            `  exec ${fishCommandString(command)};`,
            "fi",
          ].join("\n");

          return local.exec(wrappedCommand, cwd, options);
        },
      },
    };
  });
}
