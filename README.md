# Dotfiles

A modular, clean, and XDG-compliant configuration suite for Linux environments featuring Neovim, Kitty, Tmux, and Zsh.

> [!TIP]
> **For AI Assistants & Quick Lookup**:
> To quickly explore the repository hierarchy, locate specific configuration files, and see their target OS paths without loading excessive context, please inspect [**`structure.md`**](structure.md).

---

## Architecture & Philosophy

- **XDG Base Directory Compliance**: All configurations reside under `$HOME/.config` (`$XDG_CONFIG_HOME`) to keep `$HOME` clean and standardized.
- **Zsh Clean Bootstrap**: A lightweight root `~/.zshenv` sets `ZDOTDIR="$HOME/.config/zsh"`, moving all Zsh startup, history, and cache files inside `~/.config/zsh/`.
- **Modularity**: Neovim and Zsh configurations are split into focused, single-responsibility files for maintainability and clarity.
- **Portability & Automation**: Automated deployment and toolchain provisioning via [`install.sh`](install.sh).

---

## Core Toolchain & Stack

| Component | Tool / Framework | Description |
| :--- | :--- | :--- |
| **Editor** | [Neovim](https://neovim.io/) (>= 0.10) | Modern text editor powered by `lazy.nvim`, LSP, Treesitter, Conform, and Snacks.nvim |
| **Shell** | [Zsh](https://www.zsh.org/) | Modular shell setup with Oh-My-Zsh, custom completions, aliases, and functions |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal emulator with Noctalia & Nord color themes |
| **Multiplexer** | [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer configured with TPM, continuum, and resurrect |
| **Git Client** | [Lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for Git operations |
| **System Info** | [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | Fast, responsive system information fetch tool with adaptive terminal sizing |
| **Services** | [systemd (user)](https://www.freedesktop.org/software/systemd/man/systemd.service.html) | User-level background services (e.g. `rclone@.service`) |

---

## Quick Start & Automated Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Mr0r4ng3/configs.git ~/.myconfigs
cd ~/.myconfigs
```

### 2. Run the Automated Installer

The included [`install.sh`](install.sh) script automatically detects your distribution, installs required system packages and tools, creates all necessary symlinks, and bootstraps plugins:

```bash
chmod +x install.sh
./install.sh
```

#### Installer Flags:

| Flag | Description |
| :--- | :--- |
| `--dry-run` | Preview actions (package installations and symlinks) without modifying the system |
| `--symlinks-only` | Only create symbolic links and bootstrap plugins without installing system packages |
| `--backup` | Create timestamped backups of existing non-symlink configurations before overwriting |
| `--no-pkg` | Skip system package installation step |
| `--help` | Show usage options and flags |

---

## Manual Deployment via Symbolic Links

If you prefer to link configuration files manually without using the installer script:

```bash
# Ensure target base directories exist
mkdir -p "$HOME/.config" "$HOME/.config/systemd/user"

# Root environment bootstrap (redirects ZDOTDIR to ~/.config/zsh)
ln -sfn "$HOME/.myconfigs/.zshenv" "$HOME/.zshenv"

# ~/.config module directories
ln -sfn "$HOME/.myconfigs/config/fastfetch" "$HOME/.config/fastfetch"
ln -sfn "$HOME/.myconfigs/config/kitty" "$HOME/.config/kitty"
ln -sfn "$HOME/.myconfigs/config/lazygit" "$HOME/.config/lazygit"
ln -sfn "$HOME/.myconfigs/config/nvim" "$HOME/.config/nvim"
ln -sfn "$HOME/.myconfigs/config/tmux" "$HOME/.config/tmux"
ln -sfn "$HOME/.myconfigs/config/zsh" "$HOME/.config/zsh"

# Systemd user services
ln -sfn "$HOME/.myconfigs/config/systemd/user/rclone@.service" "$HOME/.config/systemd/user/rclone@.service"
systemctl --user daemon-reload
```

---

## Component Highlights

### 🐚 Zsh Shell
- **Zero-Clutter Home**: All configuration and state files (`.zshrc`, `.zshenv`, history, compdump) reside inside `~/.config/zsh/`.
- **Modular Scripts**: Separated into [aliases](config/zsh/aliases.zsh), [completion](config/zsh/completion.zsh), [environment variables](config/zsh/env.zsh), [functions](config/zsh/functions.zsh), [history](config/zsh/history.zsh), [keybindings](config/zsh/keybindings.zsh), and [options](config/zsh/options.zsh).
- **Adaptive Fastfetch Hook**: Automatically runs [Fastfetch](config/zsh/fastfetch.zsh) on interactive shell startup, dynamically scaling output between full, compact, or suppressed based on current terminal dimensions.
- **Local Overrides**: Machine-specific tokens and custom environment variables can be placed in `~/.config/zsh/local.zsh` (gitignored).

### 📝 Neovim
- **Plugin Management**: Bootstrapped with [`lazy.nvim`](config/nvim/lua/config/lazy.lua) and locked with [`lazy-lock.json`](config/nvim/lazy-lock.json).
- **Core Plugins**:
  - **LSP & Formatting**: Built-in LSP client via `mason.nvim` and `mason-lspconfig`, with automated formatters via `conform.nvim`.
  - **Syntax & UI**: Treesitter syntax highlighting, Lualine statusline, Which-Key popup helper.
  - **Productivity**: `oil.nvim` for buffer-like filesystem navigation, `snacks.nvim` for fuzzy finding and command palette, and `gitsigns.nvim` for git status.

### 🪟 Tmux
- **Prefix Key**: Rebound to `Ctrl + Space`.
- **Session Persistence**: Automated background session saving and restoration across reboots via `tmux-resurrect` and `tmux-continuum`.
- **Navigation & Splits**: Split horizontal with `|` and vertical with `-`. Navigate panes using `Alt + Arrow keys` without prefix.

### ☁️ Systemd User Services
- **Rclone Remote Mounting**: User unit template [`rclone@.service`](config/systemd/user/rclone@.service) enables automated mounting of cloud remotes:
  ```bash
  systemctl --user enable --now rclone@<remote_name>.service
  ```

---

## File Structure Reference

For a complete and detailed mapping of all repository files to their target OS locations, see [**`structure.md`**](structure.md).
