---
name: tweak-skill
description: Tune an existing skill after use by comparing the skill text, the agent's actual work, and the user's feedback, then drafting concise targeted changes before editing.
---

# Tweak Skill

Use when the user wants to adjust an existing skill based on how it behaved in a real run.

Cross-reference three things:

- the skill content;
- the agent's actual work or transcript from the run being critiqued;
- the user's feedback about what should change.

First, propose concise targeted edits in chat. Prefer the smallest wording change that would have steered the run better. Avoid turning one incident into broad policy unless the pattern is clear.

Only write to the skill after the user approves the draft changes. When editing, preserve the skill's existing style and remove obsolete or conflicting wording rather than layering on exceptions.

Treat this as small repeated tuning, not a rewrite. If the feedback implies a larger redesign, say so and separate the narrow patch from the broader question.
