# Subagents

Available harnesses:

- Codex CLI (`codex exec` / `codex review`)
- Claude Code (`claude -p`)
- Cursor (`agent -p`)
- Pi: interactive harness using OpenAI Codex models; installed only on the Macbook.

Consider the following table:

| model         | cost | intelligence | taste |
|---------------|------|--------------|-------|
| gpt-5.6-sol   | 8    | 9            | 7     |
| gpt-5.6-terra | 9    | 6            | 6     |
| gpt-5.6-luna  | 10   | 5            | 5     |
| opus-4.8      | 6    | 7            | 8     |
| fable-5       | 4    | 9            | 9     |
| grok-4.5      | 7    | 6            | 7     |

- Rankings, higher = better. Cost reflects how much I actually pay for subscriptions.
- Intelligence covers how hard a problem the model can solve unsupervised; taste covers UI/UX, code quality, API design and copy.
- These are defaults/suggestions, not hard limits.
- Judge the output not the price tag; rerun with smarter models if the quality bar isn't met.
- Cost is a tie-breaker only; pick from intelligence/taste depending on the task.
- Bulk/mechanical work -> gpt-5.6-sol.
- User-facing (UI, copy) needs taste >= 7.
- Pass prompts as if they were subagents - no piping massive git diffs into context; let the agent do its own tool calls/actions.
- Don't override sandbox/permissions defaults unless you explicitly want read-only.
- Don't be impatient; models may run for tens of minutes so give them plenty of time before assuming they are hanging.

