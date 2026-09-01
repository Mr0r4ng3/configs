# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
# Ensure path variables only contain unique values (no duplicates)
typeset -U path cdpath fpath manpath

path=(
    /home/mr0rang3/.local/bin
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
