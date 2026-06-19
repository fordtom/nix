#!/usr/bin/env bash
# Claude Code status line
# Fields: dir | model | effort | ctx% | tokens | 5h remaining+epoch | 7d remaining+epoch

input=$(cat)

# --- dir ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // ""')

# --- effort ---
effort=$(echo "$input" | jq -r '.effort.level // ""')

# --- context ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx=$(printf "%.0f%%" "$used_pct")
else
  ctx="ctx:—"
fi

# --- tokens (current context window: input incl. cache + most recent output) ---
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((total_in + total_out))
if [ "$total_tokens" -gt 0 ]; then
  if [ "$total_tokens" -ge 1000 ]; then
    tok=$(awk "BEGIN { printf \"%.1fk\", $total_tokens/1000 }")
  else
    tok="${total_tokens}"
  fi
else
  tok="—"
fi

# --- 5h rate limit ---
five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_used" ]; then
  five_rem=$(awk "BEGIN { printf \"%.0f\", 100 - $five_used }")
  if [ -n "$five_resets" ]; then
    five_time=$(date -r "$five_resets" "+%H:%M" 2>/dev/null || date -d "@$five_resets" "+%H:%M" 2>/dev/null)
    five="${five_rem}% @${five_time}"
  else
    five="${five_rem}%"
  fi
else
  five="—"
fi

# --- 7d rate limit ---
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [ -n "$week_used" ]; then
  week_rem=$(awk "BEGIN { printf \"%.0f\", 100 - $week_used }")
  if [ -n "$week_resets" ]; then
    week_time=$(date -r "$week_resets" "+%a %H:%M" 2>/dev/null || date -d "@$week_resets" "+%a %H:%M" 2>/dev/null)
    week="${week_rem}% @${week_time}"
  else
    week="${week_rem}%"
  fi
else
  week="—"
fi

printf "%s  %s  %s  %s  %s  5h:%s  7d:%s" \
  "$dir" "$model" "$effort" "$ctx" "$tok" "$five" "$week"
