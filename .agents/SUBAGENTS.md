# Subagents

## Harnesses

- Codex CLI (`codex exec` / `codex review`)
- Claude Code (`claude -p`)
- Pi: interactive harness using OpenAI Codex models only

Builtin subagent tools are also in each harness for their own respective model families

## Models

Consider the following table:

| model         | cost | intelligence | taste |
|---------------|------|--------------|-------|
| gpt-5.6-sol   | 7    | 8            | 7     |
| gpt-5.6-terra | 9    | 6            | 6     |
| gpt-5.6-luna  | 10   | 5            | 5     |
| fable-5       | 4    | 9            | 9     |

- Rankings, higher = better. Cost reflects how much I actually pay for subscriptions.
- Intelligence covers how hard a problem the model can solve unsupervised; taste covers UI/UX, code quality, API design and copy.
- These are defaults/suggestions, not hard limits.
- Judge the output not the price tag; rerun with smarter models if the quality bar isn't met.
- Cost is a tie-breaker only; pick from intelligence/taste depending on the task.

## Guidelines

- Don't prompt by piping git diffs/command outputs into the CLIs (piping PROMPT.md is fine); treat the CLIs like real subagents.
- Don't override sandbox/permissions defaults unless you explicitly want read-only.
- Don't be impatient; models may run for tens of minutes so give them plenty of time before assuming they are hanging.

## Effort and Reasoning

Generally speaking, effort is proportional to the open-endedness of the task. For example:

- 'mass rename X throughout a project': medium/small model with low reasoning -> clear/easy outcome and fairly mechanical work.
- 'Research and design the API for X': Big model/high reasoning -> very open ended, requires opinionated decision making and reasoning.

I would basically use either 'high' or 'low' effort for all model families (xhigh is diminishing returns and medium is an awkward middle ground).

