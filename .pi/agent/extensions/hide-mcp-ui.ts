import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type StatusUI = {
  setStatus(key: string, text: string | undefined): void;
};

export default function (pi: ExtensionAPI) {
  let restore: (() => void) | undefined;

  pi.on("session_start", (_event, ctx) => {
    restore?.();

    pi.setActiveTools(pi.getActiveTools().filter((name) => name !== "mcp"));

    const ui = ctx.ui as StatusUI;
    const setStatus = ui.setStatus.bind(ui);
    const suppressMcpStatus: StatusUI["setStatus"] = (key, text) => {
      setStatus(key, key === "mcp" ? undefined : text);
    };

    ui.setStatus = suppressMcpStatus;
    setStatus("mcp", undefined);

    restore = () => {
      if (ui.setStatus === suppressMcpStatus) {
        ui.setStatus = setStatus;
      }
      setStatus("mcp", undefined);
    };
  });

  pi.on("session_shutdown", () => {
    restore?.();
    restore = undefined;
  });
}
