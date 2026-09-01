#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Automated Installation & Deployment Script
# ==============================================================================
# Usage:
#   ./install.sh [options]
#
# Options:
#   -h, --help           Show this help message and exit
#   -d, --dry-run        Simulate operations without making changes
#   -s, --symlinks-only  Deploy symlinks and bootstrap plugins without installing packages
#   -b, --backup         Back up existing configurations before linking
#   --no-pkg             Skip system package manager installation
# ==============================================================================

set -euo pipefail

# Script directory (root of dotfiles repository)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${REPO_DIR}/config"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Flags
DRY_RUN=false
SYMLINKS_ONLY=false
BACKUP_EXISTING=false
INSTALL_PACKAGES=true

# Formatting colors
CLR_RESET="\033[0m"
CLR_INFO="\033[1;34m"
CLR_SUCCESS="\033[1;32m"
CLR_WARN="\033[1;33m"
CLR_ERROR="\033[1;31m"
CLR_TITLE="\033[1;35m"

# ------------------------------------------------------------------------------
# Logging Functions
# ------------------------------------------------------------------------------
log_title()   { echo -e "\n${CLR_TITLE}==> $1${CLR_RESET}"; }
log_info()    { echo -e "${CLR_INFO}[INFO]${CLR_RESET} $1"; }
log_success() { echo -e "${CLR_SUCCESS}[OK]${CLR_RESET} $1"; }
log_warn()    { echo -e "${CLR_WARN}[WARN]${CLR_RESET} $1"; }
log_error()   { echo -e "${CLR_ERROR}[ERROR]${CLR_RESET} $1" >&2; }

# ------------------------------------------------------------------------------
# Usage / Help
# ------------------------------------------------------------------------------
show_help() {
  cat <<EOF
Dotfiles Automated Installer

Usage:
  ./install.sh [options]

Options:
  -h, --help           Show this help message
  -d, --dry-run        Simulate actions without modifying files or installing packages
  -s, --symlinks-only  Deploy symlinks and initialize plugins (skips package installation)
  -b, --backup         Create a backup of conflicting non-symlink directories
  --no-pkg             Skip system package manager installation
EOF
}

# ------------------------------------------------------------------------------
# Parse Arguments
# ------------------------------------------------------------------------------
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
    -s|--symlinks-only)
      SYMLINKS_ONLY=true
      INSTALL_PACKAGES=false
      shift
      ;;
    -b|--backup)
      BACKUP_EXISTING=true
      shift
      ;;
    --no-pkg)
      INSTALL_PACKAGES=false
      shift
      ;;
    *)
      log_error "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

# ------------------------------------------------------------------------------
# Execute command or print simulation
# ------------------------------------------------------------------------------
run_cmd() {
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CLR_WARN}(dry-run)${CLR_RESET} $*"
  else
    "$@"
  fi
}

# ------------------------------------------------------------------------------
# OS & Distribution Detection
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Package Installation
# ------------------------------------------------------------------------------
install_system_packages() {
  detect_distro
  log_title "Step 1: Installing System Dependencies (${DISTRO_ID})"

  if [ "$INSTALL_PACKAGES" = false ]; then
    log_info "Package installation skipped by flag."
    return 0
  fi

  case "$DISTRO_ID" in
    arch|cachyos|manjaro|endeavouros)
      local pkgs=(
        zsh git curl fzf ripgrep fd eza bat lazygit rclone jq
        unzip p7zip zstd neovim gcc make cmake nodejs npm python
        python-pip luarocks kitty tmux wl-clipboard ttf-jetbrains-mono-nerd
      )
      log_info "Installing Arch/CachyOS packages via pacman..."
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
        zsh git curl fzf ripgrep fd-find eza bat lazygit rclone jq
        unzip p7zip zstd neovim gcc make cmake nodejs npm python3
        python3-pip kitty tmux wl-clipboard jetbrains-mono-fonts-all
      )
      log_info "Installing Fedora packages via dnf..."
      run_cmd sudo dnf install -y "${pkgs[@]}"
      ;;

    ubuntu|debian|pop)
      local pkgs=(
        zsh git curl fzf ripgrep fd-find bat rclone jq
        unzip p7zip-full zstd neovim build-essential cmake
        nodejs npm python3 python3-pip kitty tmux wl-clipboard
      )
      log_info "Installing Debian/Ubuntu packages via apt..."
      run_cmd sudo apt update -y
      run_cmd sudo apt install -y "${pkgs[@]}"
      ;;

    *)
      log_warn "Unsupported or unmanaged distribution ($DISTRO_ID). Please ensure required tools are installed manually."
      ;;
  esac
}

# ------------------------------------------------------------------------------
# Deploy Symbolic Links
# ------------------------------------------------------------------------------
deploy_symlinks() {
  log_title "Step 2: Deploying Symbolic Links"

  # Ensure destination directories exist
  run_cmd mkdir -p "$TARGET_CONFIG_DIR" "$TARGET_CONFIG_DIR/systemd/user"

  # 1. Link .zshenv to $HOME/.zshenv
  local zshenv_source="${REPO_DIR}/.zshenv"
  local zshenv_target="$HOME/.zshenv"
  
  if [ -e "$zshenv_target" ] && [ ! -L "$zshenv_target" ] && [ "$BACKUP_EXISTING" = true ]; then
    log_info "Backing up existing ${zshenv_target} to ${BACKUP_DIR}/.zshenv"
    run_cmd mkdir -p "$BACKUP_DIR"
    run_cmd mv "$zshenv_target" "$BACKUP_DIR/.zshenv"
  fi
  
  log_info "Linking ${zshenv_source} -> ${zshenv_target}"
  run_cmd ln -sfn "$zshenv_source" "$zshenv_target"

  # 2. Link each module under config/ to ~/.config/
  if [ -d "$CONFIG_DIR" ]; then
    for module in "$CONFIG_DIR"/*; do
      [ -e "$module" ] || continue
      local module_name
      module_name="$(basename "$module")"

      # Handle systemd/user specially
      if [ "$module_name" = "systemd" ]; then
        local systemd_src="$CONFIG_DIR/systemd/user"
        if [ -d "$systemd_src" ]; then
          for unit in "$systemd_src"/*; do
            [ -e "$unit" ] || continue
            local unit_name
            unit_name="$(basename "$unit")"
            local unit_target="$TARGET_CONFIG_DIR/systemd/user/$unit_name"
            log_info "Linking systemd unit ${unit} -> ${unit_target}"
            run_cmd ln -sfn "$unit" "$unit_target"
          done
        fi
        continue
      fi

      local target_path="$TARGET_CONFIG_DIR/$module_name"

      # Handle backup if target exists and is not already a symlink
      if [ -e "$target_path" ] && [ ! -L "$target_path" ] && [ "$BACKUP_EXISTING" = true ]; then
        log_info "Backing up existing ${target_path} to ${BACKUP_DIR}/${module_name}"
        run_cmd mkdir -p "$BACKUP_DIR"
        run_cmd mv "$target_path" "$BACKUP_DIR/${module_name}"
      fi

      log_info "Linking module ${module} -> ${target_path}"
      run_cmd ln -sfn "$module" "$target_path"
    done
  fi

  log_success "Symbolic links successfully created."
}

# ------------------------------------------------------------------------------
# Toolchain & Plugin Bootstrapping
# ------------------------------------------------------------------------------
bootstrap_toolchain() {
  log_title "Step 3: Bootstrapping Plugins & Toolchains"

  # 1. Oh-My-Zsh Unattended Installation
  local omz_dir="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
  if [ ! -d "$omz_dir" ]; then
    log_info "Installing Oh-My-Zsh into ${omz_dir}..."
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${CLR_WARN}(dry-run)${CLR_RESET} sh -c curl ... install.sh into ${omz_dir}"
    else
      export ZSH="$omz_dir"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi
  else
    log_info "Oh-My-Zsh already installed at ${omz_dir}."
  fi

  # 2. Tmux Plugin Manager (TPM)
  local tpm_dir="${CONFIG_DIR}/tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    log_info "Cloning Tmux Plugin Manager (TPM)..."
    run_cmd git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    log_info "TPM already present at ${tpm_dir}."
  fi

  # 3. Systemd User Daemon Reload
  if command -v systemctl >/dev/null 2>&1; then
    log_info "Reloading systemd user daemon..."
    run_cmd systemctl --user daemon-reload || true
  fi

  log_success "Toolchain bootstrapping completed."
}

# ------------------------------------------------------------------------------
# Main Execution
# ------------------------------------------------------------------------------
main() {
  echo -e "${CLR_TITLE}======================================================${CLR_RESET}"
  echo -e "${CLR_TITLE}        Dotfiles Installation & Setup Manager         ${CLR_RESET}"
  echo -e "${CLR_TITLE}======================================================${CLR_RESET}"
  
  if [ "$DRY_RUN" = true ]; then
    log_warn "DRY RUN MODE ENABLED: No system modifications will be made."
  fi

  install_system_packages
  deploy_symlinks
  bootstrap_toolchain

  log_title "Setup Complete!"
  echo -e "All configurations have been linked and initialized."
  echo -e "To apply shell changes immediately: ${CLR_INFO}source ~/.config/zsh/.zshrc${CLR_RESET}"
  echo -e "To install/update Tmux plugins: open tmux and press ${CLR_INFO}Ctrl+Space + I${CLR_RESET}"
  echo -e "To initialize Neovim plugins: launch ${CLR_INFO}nvim${CLR_RESET}\n"
}

main "$@"

