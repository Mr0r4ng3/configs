# ==============================================================================
# System & Package Management
# ==============================================================================

if (( $+commands[pacman] )); then
  alias sysupdate="sudo pacman -Syu --noconfirm"
elif (( $+commands[apt] )); then
  alias sysupdate="sudo apt update -y && sudo apt upgrade -y"
fi

# ==============================================================================
# Editor & Config Shortcuts
# ==============================================================================
if (( $+commands[nvim] )); then
  alias vi="nvim"
  alias vim="nvim"
fi

alias reload='source "$ZDOTDIR/.zshrc"'

# ==============================================================================
# File Listing & Inspection
# ==============================================================================
alias l="ls"

if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first --git'
  alias la='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -l'
  alias la='ls -la'
fi

# Use bat/batcat with fallback to cat
if (( $+commands[bat] )); then
  alias cat="bat --paging=never --color=always"
elif (( $+commands[batcat] )); then
  alias cat="batcat --paging=never --color=always"
fi

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety flags for core file operations
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'

# ==============================================================================
# Docker Helpers
# Using functions to prevent syntax errors when no containers/images exist
# ==============================================================================
docker-rm-all() {
  local containers
  containers="$(docker ps -aq)"
  if [[ -n "$containers" ]]; then
    docker rm -vf $containers
  else
    echo "No containers to remove."
  fi
}

docker-rmi-all() {
  local images
  images="$(docker images -aq)"
  if [[ -n "$images" ]]; then
    docker rmi -f $images
  else
    echo "No images to remove."
  fi
}

# ==============================================================================
# Global Aliases (expand anywhere on the command line)
# ==============================================================================
alias -g G='| grep -i'
alias -g L='| less'
alias -g H='| head -n'
alias -g T='| tail -n'
alias -g NE='2>/dev/null'
alias -g NUL='&>/dev/null'

# ==============================================================================
# Suffix Aliases (execute files based on extension)
# ==============================================================================
alias -s {txt,md,json,yaml,yml,toml,conf,ini}="${EDITOR:-nvim}"

if (( $+commands[xdg-open] )); then
  alias -s {pdf,png,jpg,jpeg,svg}='xdg-open'
fi
