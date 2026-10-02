# ------------------------------------------------------------------------------
# XDG BASE DIRECTORIES
# ------------------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# ------------------------------------------------------------------------------
# PATH & ENVIRONMENT
# ------------------------------------------------------------------------------
# Source Cargo environment if present
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# PNPM Home
export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"

# Ensure path variables only contain unique values (no duplicates)
typeset -U path cdpath fpath manpath

path=(
    "$HOME/.local/bin"
    "$HOME/.local/share/fnm"
    "$PNPM_HOME"
    "$PNPM_HOME/bin"
    "$HOME/.cargo/bin"
    $path                    # Includes original system paths
)

export PATH

# ------------------------------------------------------------------------------
# EDITOR
# ------------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then

  export EDITOR='nvim'

else

  export EDITOR='nano'

fi

# ------------------------------------------------------------------------------
# VISUAL EDITOR
# ------------------------------------------------------------------------------

if command -v code >/dev/null 2>&1; then

  export VISUAL='code --wait'

elif command -v subl >/dev/null 2>&1; then

  export VISUAL='subl --wait'

elif command -v xdg-open >/dev/null 2>&1; then

  export VISUAL='xdg-open'

else

  export VISUAL='$EDITOR'

fi

# ------------------------------------------------------------------------------
# PAGER
# ------------------------------------------------------------------------------

export PAGER='less'

# ------------------------------------------------------------------------------
# LANGUAGE AND LOCALE
# ------------------------------------------------------------------------------
export LANG='es_VE.UTF-8'
export LC_ALL='es_VE.UTF-8'
