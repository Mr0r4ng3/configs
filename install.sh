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
# Package Installation (Delegated to scripts/install-deps.sh)
# ------------------------------------------------------------------------------
install_system_packages() {
  log_title "Step 1: Installing System Dependencies"

  if [ "$INSTALL_PACKAGES" = false ]; then
    log_info "Package installation skipped by flag."
    return 0
  fi

  local deps_script="${REPO_DIR}/scripts/install-deps.sh"
  if [ -f "$deps_script" ]; then
    local args=()
    if [ "$DRY_RUN" = true ]; then
      args+=("-d")
    fi
    "$deps_script" "${args[@]}"
  else
    log_warn "Dependencies script not found at ${deps_script}. Skipping system packages."
  fi
}

# ------------------------------------------------------------------------------
# Deploy Symbolic Links
# ------------------------------------------------------------------------------
deploy_symlinks() {
  log_title "Step 2: Deploying Symbolic Links"

  # Ensure destination directories exist
  run_cmd mkdir -p "$TARGET_CONFIG_DIR" "$TARGET_CONFIG_DIR/systemd/user" "$HOME/.local/bin"

  # Helper function to link safely without GNU ln nesting
  link_target() {
    local src="$1"
    local dst="$2"
    local name="$3"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
      if [ -L "$dst" ]; then
        # Already a symlink: ln -sfn will replace safely
        :
      elif [ -d "$dst" ]; then
        # Destination is a real directory: ln -sfn would create a nested link inside it
        log_warn "Destination directory exists and is not a symlink: ${dst}"
        log_info "Moving existing directory to backup: ${BACKUP_DIR}/${name}"
        run_cmd mkdir -p "$BACKUP_DIR"
        run_cmd mv "$dst" "$BACKUP_DIR/${name}"
      else
        # Destination is a regular file
        if [ "$BACKUP_EXISTING" = true ]; then
          log_info "Backing up existing file ${dst} -> ${BACKUP_DIR}/${name}"
          run_cmd mkdir -p "$BACKUP_DIR"
          run_cmd mv "$dst" "$BACKUP_DIR/${name}"
        fi
      fi
    fi

    log_info "Linking ${src} -> ${dst}"
    run_cmd ln -sfn "$src" "$dst"
  }

  # 1. Link .zshenv to $HOME/.zshenv
  local zshenv_source="${REPO_DIR}/.zshenv"
  local zshenv_target="$HOME/.zshenv"
  link_target "$zshenv_source" "$zshenv_target" ".zshenv"

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
            link_target "$unit" "$unit_target" "systemd-user-${unit_name}"
          done
        fi
        continue
      fi

      local target_path="$TARGET_CONFIG_DIR/$module_name"
      link_target "$module" "$target_path" "$module_name"
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
  if [ ! -f "$tpm_dir/tpm" ]; then
    log_info "Installing Tmux Plugin Manager (TPM)..."
    run_cmd rm -rf "$tpm_dir"
    run_cmd git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    log_info "TPM already present and operational at ${tpm_dir}."
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
  echo -e "To initialize Neovim plugins: launch ${CLR_INFO}nvim${CLR_RESET}"

  local current_shell
  current_shell="$(basename "${SHELL:-}")"
  if [ "$current_shell" != "zsh" ] && command -v zsh >/dev/null 2>&1; then
    echo -e "Note: Default shell is currently ${SHELL}. To set Zsh as default: ${CLR_INFO}chsh -s $(command -v zsh)${CLR_RESET}\n"
  else
    echo ""
  fi
}

main "$@"
