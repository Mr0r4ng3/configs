#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Uninstaller & Rollback Script
# ==============================================================================
# Safely unlinks dotfiles managed by this repository and optionally restores
# previous configurations from the latest backup directory.
#
# Usage:
#   ./uninstall.sh [options]
#
# Options:
#   -h, --help           Show this help message and exit
#   -d, --dry-run        Simulate operations without making changes
#   -r, --restore        Restore backed up files from the most recent backup
#   --clean-plugins      Remove cloned TPM and Oh-My-Zsh installations
# ==============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${REPO_DIR}/config"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

DRY_RUN=false
RESTORE_BACKUP=false
CLEAN_PLUGINS=false

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
Dotfiles Uninstaller & Rollback Tool

Usage:
  ./uninstall.sh [options]

Options:
  -h, --help           Show this help message
  -d, --dry-run        Simulate actions without modifying files
  -r, --restore        Restore backed up files from the most recent ~/.config_backup_* directory
  --clean-plugins      Remove downloaded TPM and Oh-My-Zsh installations
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
    -r|--restore)
      RESTORE_BACKUP=true
      shift
      ;;
    --clean-plugins)
      CLEAN_PLUGINS=true
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

# Safely remove a symlink only if it points into this repository
unlink_if_managed() {
  local target="$1"
  local description="$2"

  if [ -L "$target" ]; then
    local destination
    destination="$(readlink -f "$target" 2>/dev/null || true)"
    if [[ "$destination" == "$REPO_DIR"* ]]; then
      log_info "Removing managed symlink: ${target} -> ${destination}"
      run_cmd rm -f "$target"
    else
      log_warn "Skipping ${target}: points outside this repository (${destination})"
    fi
  elif [ -e "$target" ]; then
    log_warn "Skipping ${target}: exists but is not a symbolic link"
  fi
}

remove_symlinks() {
  log_title "Step 1: Removing Managed Symbolic Links"

  # 1. Unlink ~/.zshenv
  unlink_if_managed "$HOME/.zshenv" "Zsh environment bootstrap"

  # 2. Unlink systemd user units
  local systemd_src="$CONFIG_DIR/systemd/user"
  if [ -d "$systemd_src" ]; then
    for unit in "$systemd_src"/*; do
      [ -e "$unit" ] || continue
      local unit_name
      unit_name="$(basename "$unit")"
      unlink_if_managed "$TARGET_CONFIG_DIR/systemd/user/$unit_name" "systemd user unit"
    done
  fi

  # 3. Unlink config modules
  if [ -d "$CONFIG_DIR" ]; then
    for module in "$CONFIG_DIR"/*; do
      [ -e "$module" ] || continue
      local module_name
      module_name="$(basename "$module")"
      [ "$module_name" = "systemd" ] && continue
      unlink_if_managed "$TARGET_CONFIG_DIR/$module_name" "config module"
    done
  fi

  log_success "Managed symbolic links removed."
}

restore_latest_backup() {
  log_title "Step 2: Restoring Latest Backup"

  # Find the newest backup directory
  local latest_backup=""
  latest_backup="$(find "$HOME" -maxdepth 1 -type d -name ".config_backup_*" 2>/dev/null | sort -r | head -n 1 || true)"

  if [ -z "$latest_backup" ] || [ ! -d "$latest_backup" ]; then
    log_warn "No backup directories (~/.config_backup_*) found to restore."
    return 0
  fi

  log_info "Found latest backup directory: ${latest_backup}"

  for item in "$latest_backup"/* "$latest_backup"/.*; do
    [ -e "$item" ] || continue
    local item_name
    item_name="$(basename "$item")"
    [ "$item_name" = "." ] || [ "$item_name" = ".." ] && continue

    if [ "$item_name" = ".zshenv" ]; then
      log_info "Restoring ${item} -> $HOME/.zshenv"
      run_cmd cp -a "$item" "$HOME/.zshenv"
    elif [[ "$item_name" == systemd-user-* ]]; then
      local unit_name="${item_name#systemd-user-}"
      log_info "Restoring ${item} -> $TARGET_CONFIG_DIR/systemd/user/$unit_name"
      run_cmd mkdir -p "$TARGET_CONFIG_DIR/systemd/user"
      run_cmd cp -a "$item" "$TARGET_CONFIG_DIR/systemd/user/$unit_name"
    else
      log_info "Restoring ${item} -> $TARGET_CONFIG_DIR/$item_name"
      run_cmd mkdir -p "$TARGET_CONFIG_DIR"
      run_cmd cp -a "$item" "$TARGET_CONFIG_DIR/$item_name"
    fi
  done

  log_success "Backup ${latest_backup} successfully restored."
}

clean_plugins() {
  log_title "Step 3: Cleaning Plugins & Toolchains"

  local tpm_dir="${CONFIG_DIR}/tmux/plugins/tpm"
  if [ -d "$tpm_dir" ]; then
    log_info "Removing TPM clone: ${tpm_dir}"
    run_cmd rm -rf "$tpm_dir"
  fi

  local omz_dir="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
  if [ -d "$omz_dir" ]; then
    log_info "Removing Oh-My-Zsh installation: ${omz_dir}"
    run_cmd rm -rf "$omz_dir"
  fi

  log_success "Plugins and toolchains cleaned."
}

main() {
  echo -e "${CLR_TITLE}======================================================${CLR_RESET}"
  echo -e "${CLR_TITLE}        Dotfiles Uninstaller & Rollback Tool          ${CLR_RESET}"
  echo -e "${CLR_TITLE}======================================================${CLR_RESET}"

  if [ "$DRY_RUN" = true ]; then
    log_warn "DRY RUN MODE ENABLED: No system modifications will be made."
  fi

  remove_symlinks

  if [ "$RESTORE_BACKUP" = true ]; then
    restore_latest_backup
  fi

  if [ "$CLEAN_PLUGINS" = true ]; then
    clean_plugins
  fi

  if command -v systemctl >/dev/null 2>&1; then
    run_cmd systemctl --user daemon-reload || true
  fi

  log_title "Uninstall Complete!"
  echo -e "Dotfiles links unlinked successfully."
  if [ "$RESTORE_BACKUP" = false ]; then
    echo -e "Tip: You can restore your previous files at any time with: ${CLR_INFO}./uninstall.sh --restore${CLR_RESET}\n"
  fi
}

main "$@"
