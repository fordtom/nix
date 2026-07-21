import { readFileSync } from "node:fs";
import { dirname } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  fuzzyFilter,
  type AutocompleteItem,
  type AutocompleteProvider,
} from "@earendil-works/pi-tui";

type Skill = {
  name: string;
  description?: string;
  path: string;
  baseDir: string;
};

const SKILL_REFERENCE =
  /(?<![A-Za-z0-9_$])\$([a-z0-9](?:[a-z0-9-]{0,62}[a-z0-9])?)(?![a-z0-9-])/g;
const MAX_SUGGESTIONS = 20;

function getSkills(pi: ExtensionAPI): Skill[] {
  return pi
    .getCommands()
    .filter((command) => command.source === "skill")
    .map((command) => ({
      name: command.name.slice("skill:".length),
      description: command.description,
      path: command.sourceInfo.path,
      baseDir: dirname(command.sourceInfo.path),
    }));
}

function stripFrontmatter(content: string): string {
  if (!content.startsWith("---")) return content.trim();

  const closingDelimiter = content.match(/\r?\n---(?:\r?\n|$)/);
  if (!closingDelimiter?.index) return content.trim();

  return content
    .slice(closingDelimiter.index + closingDelimiter[0].length)
    .trim();
}

function formatSkillBlock(skills: Array<Skill & { body: string }>): string {
  if (skills.length === 1) {
    const [skill] = skills;
    return `<skill name="${skill.name}" location="${skill.path}">
References are relative to ${skill.baseDir}.

${skill.body}
</skill>`;
  }

  const body = skills
    .map(
      (skill) => `## ${skill.name}

Location: ${skill.path}
References are relative to ${skill.baseDir}.

${skill.body}`,
    )
    .join("\n\n---\n\n");

  return `<skill name="${skills.map((skill) => skill.name).join(", ")}" location="multiple">
The user explicitly invoked the following skills. Follow all applicable instructions.

${body}
</skill>`;
}

function expandSkillReferences(text: string, skills: Skill[]) {
  const skillsByName = new Map(skills.map((skill) => [skill.name, skill]));
  const invokedNames = [
    ...new Set(
      [...text.matchAll(SKILL_REFERENCE)]
        .map((match) => match[1])
        .filter((name) => skillsByName.has(name)),
    ),
  ];

  if (invokedNames.length === 0) return;

  const loaded: Array<Skill & { body: string }> = [];
  const errors: string[] = [];

  for (const name of invokedNames) {
    const skill = skillsByName.get(name);
    if (!skill) continue;

    try {
      loaded.push({
        ...skill,
        body: stripFrontmatter(readFileSync(skill.path, "utf8")),
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      errors.push(`$${name}: ${message}`);
    }
  }

  if (loaded.length === 0) return { errors };

  const loadedNames = new Set(loaded.map((skill) => skill.name));
  const userText = text.replace(
    SKILL_REFERENCE,
    (reference, name: string, offset: number, source: string) => {
      if (!loadedNames.has(name)) return reference;

      const alreadyCode =
        source[offset - 1] === "`" &&
        source[offset + reference.length] === "`";
      return alreadyCode ? reference : `\`${reference}\``;
    },
  );

  return {
    text: `${formatSkillBlock(loaded)}\n\n${userText}`,
    errors,
  };
}

function extractSkillQuery(textBeforeCursor: string): string | undefined {
  return textBeforeCursor.match(/(?:^|[\s([{:;,])\$([a-z0-9-]*)$/)?.[1];
}

function createAutocompleteProvider(
  current: AutocompleteProvider,
  pi: ExtensionAPI,
): AutocompleteProvider {
  return {
    triggerCharacters: ["$"],

    async getSuggestions(lines, cursorLine, cursorCol, options) {
      const textBeforeCursor = (lines[cursorLine] ?? "").slice(0, cursorCol);
      const query = extractSkillQuery(textBeforeCursor);
      if (query === undefined) {
        return current.getSuggestions(lines, cursorLine, cursorCol, options);
      }

      const items = fuzzyFilter(getSkills(pi), query, (skill) => skill.name)
        .slice(0, MAX_SUGGESTIONS)
        .map<AutocompleteItem>((skill) => ({
          value: `$${skill.name}`,
          label: `$${skill.name}`,
          description: skill.description,
        }));

      if (items.length === 0) {
        return current.getSuggestions(lines, cursorLine, cursorCol, options);
      }

      return { items, prefix: `$${query}` };
    },

    applyCompletion(lines, cursorLine, cursorCol, item, prefix) {
      if (!prefix.startsWith("$")) {
        return current.applyCompletion(
          lines,
          cursorLine,
          cursorCol,
          item,
          prefix,
        );
      }

      const line = lines[cursorLine] ?? "";
      const beforePrefix = line.slice(0, cursorCol - prefix.length);
      const afterCursor = line.slice(cursorCol);
      const suffix = afterCursor.startsWith(" ") ? "" : " ";
      const newLines = [...lines];
      newLines[cursorLine] = `${beforePrefix}${item.value}${suffix}${afterCursor}`;

      return {
        lines: newLines,
        cursorLine,
        cursorCol: beforePrefix.length + item.value.length + suffix.length,
      };
    },

    shouldTriggerFileCompletion(lines, cursorLine, cursorCol) {
      return (
        current.shouldTriggerFileCompletion?.(lines, cursorLine, cursorCol) ??
        true
      );
    },
  };
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.addAutocompleteProvider((current) =>
      createAutocompleteProvider(current, pi),
    );
  });

  pi.on("input", (event, ctx) => {
    const expansion = expandSkillReferences(event.text, getSkills(pi));
    if (!expansion) return { action: "continue" };

    if (expansion.errors.length > 0 && ctx.hasUI) {
      ctx.ui.notify(
        `Could not load skill references:\n${expansion.errors.join("\n")}`,
        "error",
      );
    }

    if (!expansion.text) return { action: "continue" };

    return {
      action: "transform",
      text: expansion.text,
      images: event.images,
    };
  });
}
