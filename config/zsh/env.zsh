# ==============================================================================
# Node Version Manager (NVM)
# ==============================================================================
# Source NVM if installed system-wide (e.g., via pacman on Arch)
[[ -s /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

# Fallback for standard user-level NVM installation
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
