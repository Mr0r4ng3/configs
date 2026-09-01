# ==============================================================================
# Completion System Initialization
# ==============================================================================
# Cache dump path in XDG cache directory
ZCOMPDUMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZCOMPDUMP_DIR" ]] && mkdir -p "$ZCOMPDUMP_DIR"
export ZSH_COMPDUMP="$ZCOMPDUMP_DIR/.zcompdump-${ZSH_VERSION}"

# Load completion system
autoload -Uz compinit

# Regenerate .zcompdump once a day to keep shell startup fast
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# ==============================================================================
# Completion Styles & Behavior (zstyle)
# ==============================================================================
# Use menu selection: navigate suggestions with Tab or arrow keys
zstyle ':completion:*' menu select

# Case-insensitive matching, partial-word and substring completion
# (e.g. 'doc' matches 'Documents', 'foo' matches 'my_foo_bar')
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Group matches by category and show descriptive headers
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- No matches found --%f'

# Colorize completion items matching the LS_COLORS variable
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Enable caching of expensive completions (e.g. pacman, apt, git)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Prevent completing current directory entries when prefix with ../
zstyle ':completion:*' ignore-parents parent pwd ..
