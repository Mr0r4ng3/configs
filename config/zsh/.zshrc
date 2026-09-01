# ==============================================================================
# Path definitions
# ==============================================================================
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"

# ==============================================================================
# Auto-install Oh My Zsh if not present
# ==============================================================================
if [[ ! -d "$ZSH" ]]; then
  echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# ==============================================================================
# Oh My Zsh Core Configuration
# ==============================================================================
ZSH_THEME="robbyrussell"

# Standard Oh My Zsh plugins
plugins=(
  git
  sudo
)

# Load Oh My Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ==============================================================================
# Modular Config Loader
# Loads all *.zsh files from ZDOTDIR (except local.zsh)
# ==============================================================================
if [[ -d "$ZDOTDIR" ]]; then
  for module in "$ZDOTDIR"/*.zsh; do
    # Ensure file exists and is not the local overrides file
    [[ -f "$module" && "$module:t" != "local.zsh" ]] && source "$module"
  done
  unset module
fi

# ==============================================================================
# Local overrides (gitignored, for machine-specific tokens/paths)
# ==============================================================================
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
