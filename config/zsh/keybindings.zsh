# ==============================================================================
# Editor Mode
# ==============================================================================
# Use emacs keybindings by default (standard bash/readline shortcuts)
bindkey -e

# ==============================================================================
# History Search (Up / Down arrows match typed prefix)
# ==============================================================================
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Standard arrow keys
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Application keypad mode support (terminfo fallbacks)
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" down-line-or-beginning-search

# ==============================================================================
# Word & Line Navigation
# ==============================================================================
# Ctrl + Left/Right arrows: move backward/forward by word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Alt + Left/Right arrows (alternative terminal fallback)
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word

# Home / End keys: move to start/end of the line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line
[[ -n "$terminfo[kend]" ]] && bindkey "$terminfo[kend]" end-of-line

# Delete key
bindkey '^[[3~' delete-char
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char

# Ctrl + Backspace / Ctrl + W: delete previous word
bindkey '^H' backward-kill-word
bindkey '^W' backward-kill-word

# ==============================================================================
# Command Line Editing in $EDITOR
# ==============================================================================
# Press Ctrl + X, Ctrl + E to edit the current command buffer in Neovim/Nano
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
