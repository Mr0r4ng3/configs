# ==============================================================================
# History File Configuration (XDG-compliant)
# ==============================================================================
# Ensure directory exists before defining HISTFILE
HIST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
[[ ! -d "$HIST_DIR" ]] && mkdir -p "$HIST_DIR"

export HISTFILE="$HIST_DIR/history"
export HISTSIZE=50000      # Max events stored in internal memory
export SAVEHIST=50000      # Max events saved to the history file

# ==============================================================================
# History Options (setopt)
# ==============================================================================
# Write to the history file immediately, not when the shell exits
setopt INC_APPEND_HISTORY

# Share history across all concurrent zsh sessions
setopt SHARE_HISTORY

# Do not record an entry that was just recorded again
setopt HIST_IGNORE_DUPS

# Delete older duplicate entries on file write, keeping only unique ones
setopt HIST_IGNORE_ALL_DUPS

# Remove superfluous blanks before recording an entry
setopt HIST_REDUCE_BLANKS

# Do not enter lines starting with a space into history
setopt HIST_IGNORE_SPACE

# Save timestamps and elapsed execution duration
setopt EXTENDED_HISTORY

# Do not execute immediately when using history expansion (e.g. !!)
setopt HIST_VERIFY

# Expire duplicate entries first when trimming history size
setopt HIST_EXPIRE_DUPS_FIRST
