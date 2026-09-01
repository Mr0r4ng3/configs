# ==============================================================================
# Fastfetch Adaptive Shell Startup Hook
# Dynamically adjusts output based on active terminal dimensions
# ==============================================================================

# Only execute in interactive shells
if [[ -o interactive ]] && (( $+commands[fastfetch] )); then
  # Determine current terminal width and height
  local term_cols="${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}"
  local term_lines="${LINES:-$(tput lines 2>/dev/null || echo 24)}"

  # 1. Tiny terminals, floating popups, or narrow splits (< 60 cols or < 15 lines)
  # Suppress output to maintain a clean, distraction-free prompt
  if (( term_cols < 60 || term_lines < 15 )); then
    return 0

  # 2. Medium terminals or split panes (60 <= cols < 100)
  # Run compact layout with a small ASCII logo
  elif (( term_cols < 100 )); then
    fastfetch --logo small \
      --structure Title:OS:Kernel:Uptime:Shell:Terminal:Memory:Colors \
      2>/dev/null

  # 3. Full width / large terminal windows (>= 100 cols)
  # Run full styled configuration with full ASCII logo
  else
    fastfetch 2>/dev/null
  fi
fi

