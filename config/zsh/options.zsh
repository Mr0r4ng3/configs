# ==============================================================================
# Directory Navigation
# ==============================================================================
# Change directory just by typing its path without 'cd'
setopt AUTO_CD

# Automatically push the previous directory onto the directory stack
setopt AUTO_PUSHD

# Do not push multiple copies of the same directory onto the stack
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd
setopt PUSHD_SILENT

# ==============================================================================
# Expansion & Globbing
# ==============================================================================
# Enable extended globbing features (e.g., ^file, **/, (x|y))
setopt EXTENDED_GLOB

# Case-insensitive globbing matching
setopt NO_CASE_GLOB

# Allow comments starting with '#' even in interactive shells
setopt INTERACTIVE_COMMENTS

# Do not beep on ambiguous completions or errors
setopt NO_BEEP

# ==============================================================================
# Job & Process Control
# ==============================================================================
# Report the status of background jobs immediately, rather than before next prompt
setopt NOTIFY

# Prevent background jobs from being terminated when the terminal closes
setopt NO_HUP

# Resume existing job if argument matches suspended task name instead of creating new
setopt AUTO_RESUME

# ==============================================================================
# Safety & Correction
# ==============================================================================
# Try to correct the spelling of commands
setopt CORRECT

# Prevent '>' from overwriting existing files; force with '>!' instead
setopt CLOBBER
