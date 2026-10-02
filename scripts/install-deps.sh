#!/usr/bin/env bash
# ==============================================================================
# System Dependencies Installer
# ==============================================================================
# Installs core terminal, editor, multiplexer, fonts, and CLI dependencies
# across supported Linux distributions (Arch, Fedora, Debian/Ubuntu).
#
# Usage:
#   ./scripts/install-deps.sh [options]
#
# Options:
#   -h, --help     Show this help message and exit
#   -d, --dry-run  Simulate package installation without modifying the system
# ==============================================================================

set -euo pipefail

DRY_RUN=false

CLR_RESET="\033[0m"
CLR_INFO="\033[1;34m"
CLR_SUCCESS="\033[1;32m"
CLR_WARN="\033[1;33m"
CLR_ERROR="\033[1;31m"
CLR_TITLE="\033[1;35m"

log_title()   { echo -e "\n${CLR_TITLE}==> $1${CLR_RESET}"; }
log_info()    { echo -e "${CLR_INFO}[INFO]${CLR_RESET} $1"; }
log_success() { echo -e "${CLR_SUCCESS}[OK]${CLR_RESET} $1"; }
log_warn()    { echo -e "${CLR_WARN}[WARN]${CLR_RESET} $1"; }
log_error()   { echo -e "${CLR_ERROR}[ERROR]${CLR_RESET} $1" >&2; }

show_help() {
  cat <<EOF
System Dependencies Installer

Usage:
  ./scripts/install-deps.sh [options]

Options:
  -h, --help     Show this help message
  -d, --dry-run  Simulate package installation commands
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      log_error "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

run_cmd() {
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CLR_WARN}(dry-run)${CLR_RESET} $*"
  else
    "$@"
  fi
}

detect_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_ID_LIKE="${ID_LIKE:-}"
  else
    DISTRO_ID="unknown"
    DISTRO_ID_LIKE=""
  fi
}

main() {
  detect_distro
  log_title "Installing System Dependencies (${DISTRO_ID})"

  if [ "$DRY_RUN" = true ]; then
    log_warn "DRY RUN MODE ENABLED: No system modifications will be made."
  fi

  local distro_family="unknown"
  case "$DISTRO_ID" in
    arch|cachyos|manjaro|endeavouros|artix|arcolinux|garuda)
      distro_family="arch"
      ;;
    fedora|nobara|bazzite|rhel|centos|rocky|almalinux)
      distro_family="fedora"
      ;;
    ubuntu|debian|pop|linuxmint|elementary|zorin|kali|raspbian)
      distro_family="debian"
      ;;
    *)
      case "$DISTRO_ID_LIKE" in
        *arch*)
          distro_family="arch"
          ;;
        *fedora*|*rhel*)
          distro_family="fedora"
          ;;
        *debian*|*ubuntu*)
          distro_family="debian"
          ;;
        *)
          distro_family="unknown"
          ;;
      esac
      ;;
  esac

  case "$distro_family" in
    arch)
      local pkgs=(
        zsh git curl fzf ripgrep fd eza bat lazygit rclone jq fastfetch
        unzip p7zip zstd neovim gcc make cmake nodejs npm python
        python-pip luarocks kitty tmux wl-clipboard xclip ttf-jetbrains-mono-nerd
      )
      log_info "Installing Arch-family packages via pacman..."
      if command -v paru >/dev/null 2>&1; then
        run_cmd paru -S --needed --noconfirm "${pkgs[@]}"
      elif command -v yay >/dev/null 2>&1; then
        run_cmd yay -S --needed --noconfirm "${pkgs[@]}"
      else
        run_cmd sudo pacman -S --needed --noconfirm "${pkgs[@]}"
      fi
      ;;

    fedora)
      local pkgs=(
        zsh git curl fzf ripgrep fd-find eza bat lazygit rclone jq fastfetch
        unzip p7zip zstd neovim gcc make cmake nodejs npm python3
        python3-pip kitty tmux wl-clipboard xclip jetbrains-mono-fonts-all
      )
      log_info "Installing Fedora-family packages via dnf..."
      run_cmd sudo dnf install -y "${pkgs[@]}"
      ;;

    debian)
      local pkgs=(
        zsh git curl fzf ripgrep fd-find bat rclone jq fastfetch
        unzip p7zip-full zstd neovim build-essential cmake
        nodejs npm python3 python3-pip kitty tmux wl-clipboard xclip
        lazygit eza fonts-jetbrains-mono
      )
      log_info "Installing Debian/Ubuntu-family packages via apt..."
      run_cmd sudo apt update -y
      run_cmd sudo apt install -y "${pkgs[@]}"

      # Setup fd and bat shims in ~/.local/bin if named fdfind / batcat
      run_cmd mkdir -p "$HOME/.local/bin"
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        run_cmd ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
      fi
      if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
        run_cmd ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
      fi
      ;;

    *)
      log_error "Unsupported or unmanaged distribution ($DISTRO_ID / $DISTRO_ID_LIKE)."
      log_warn "Please ensure required tools (kitty, tmux, nvim, zsh, fonts, etc.) are installed manually."
      return 1
      ;;
  esac

  log_success "System dependencies successfully installed and verified."
}

main "$@"
