# ==============================================================================
# Directory & File Helpers
# ==============================================================================
# Create a new directory and enter it immediately
mkcd() {
  [[ -z "$1" ]] && echo "Usage: mkcd <directory_name>" && return 1
  mkdir -p "$1" && cd "$1"
}

# Go up N directories (default: 1)
up() {
  local count="${1:-1}"
  local dir=""
  while (( count-- > 0 )); do
    dir="../$dir"
  done
  cd "$dir"
}

# Universal archive extractor
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <path/file_name>.<ext>"
    return 1
  fi

  if [[ ! -f "$1" ]]; then
    echo "'$1' is not a valid file"
    return 1
  fi

  case "$1" in
    *.tar.bz2)   tar xvjf "$1"    ;;
    *.tar.gz)    tar xvzf "$1"    ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xvf "$1"     ;;
    *.tbz2)      tar xvjf "$1"    ;;
    *.tgz)       tar xvzf "$1"    ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *.tar.xz)    tar xvfJ "$1"    ;;
    *.tar.zst)   tar --zstd -xvf "$1" ;;
    *)           echo "'$1' cannot be extracted via extract()" ;;
  esac
}

# ==============================================================================
# FZF Interactive Selectors (Active if fzf is installed)
# ==============================================================================
if (( $+commands[fzf] )); then
  # Interactive cd into child directory
  fcd() {
    local dir
    dir="$(find "${1:-.}" -type d 2>/dev/null | fzf +m)" && cd "$dir"
  }

  # Search file and open in $EDITOR
  fe() {
    local file
    file="$(fzf --query="$1" --select-1 --exit-0)"
    [[ -n "$file" ]] && "${EDITOR:-nvim}" "$file"
  }

  # Interactively select and kill a process
  fkill() {
    local pid
    pid="$(ps -ef | sed 1d | fzf -m | awk '{print $2}')"
    if [[ -n "$pid" ]]; then
      echo "$pid" | xargs kill -${1:-9}
    fi
  }
fi

# ==============================================================================
# Network & Quick Reference
# ==============================================================================
# Display public and local IP addresses
myip() {
  echo "Local IP:  $(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')"
  echo "Public IP: $(curl -s ifconfig.me/ip 2>/dev/null || echo 'Unavailable')"
}

# Fetch cheat sheets directly from cht.sh
cheat() {
  [[ -z "$1" ]] && echo "Usage: cheat <command>" && return 1
  curl -s "cht.sh/$1" | "${PAGER:-less -R}"
}
