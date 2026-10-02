# Modular XDG Dotfiles Suite

A reproducible, high-performance, and XDG-compliant development environment for Linux featuring Neovim, Kitty, Tmux, Zsh, Fast Node Manager (`fnm`), and `pnpm`. Engineered for full portability across distributions (Debian/Ubuntu, Arch, Fedora) and display servers (Wayland & X11).

> [!TIP]
> **Low-Token Navigation for AI Assistants**:
> To explore file mappings and OS target paths without loading excessive context, consult [**`structure.md`**](structure.md).

---

## Quick Path

Deploy the complete environment in three steps:

```bash
# 1. Clone the repository
git clone https://github.com/Mr0r4ng3/configs.git ~/.myconfigs
cd ~/.myconfigs

# 2. Install system packages and CLI tools (requires sudo)
./scripts/install-deps.sh

# 3. Deploy symlinks and bootstrap userland plugins (safe, non-root)
./install.sh -b
```

To rollback anytime and restore previous configurations:
```bash
./uninstall.sh -r
```

---

## Lifecycle Scripts

| Script | Purpose | Key Flags | Privileges |
| :--- | :--- | :--- | :--- |
| [`install.sh`](install.sh) | Deploys symbolic links to `~/.config/`, bootstraps TPM and Oh-My-Zsh | `-d` (dry-run), `-b` (backup), `-s` (symlinks only), `--no-pkg` | Userland (non-root) |
| [`scripts/install-deps.sh`](scripts/install-deps.sh) | Installs system packages, fonts, `fnm`, and `pnpm` | `-d` (dry-run), `-h` (help) | Elevates via `sudo` |
| [`uninstall.sh`](uninstall.sh) | Safely unlinks repo dotfiles and restores backups | `-d` (dry-run), `-r` (restore backup), `--clean-plugins` | Userland (non-root) |

---

## Core Toolchain & Architecture

| Component | Tool / Framework | Role & Key Features |
| :--- | :--- | :--- |
| **Editor** | [Neovim](https://neovim.io/) (>= 0.10) | Lua config, `lazy.nvim`, Mason LSP (`lua_ls`, `pyright`, `clangd`), Conform, Oil, Snacks |
| **Shell** | [Zsh](https://www.zsh.org/) | Modular startup, Oh-My-Zsh, clean `$HOME` (`ZDOTDIR=~/.config/zsh`), adaptive Fastfetch |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal with Noctalia and Nord color palettes |
| **Multiplexer** | [Tmux](https://github.com/tmux/tmux) | Prefix `Ctrl + Space`, TPM plugins, session restore via `tmux-resurrect` & `continuum` |
| **Node.js** | [fnm](https://github.com/Schniz/fnm) | Ultra-fast Node manager with automatic `.nvmrc` version switching on `cd` |
| **Packages** | [pnpm](https://pnpm.io/) | Fast, disk-efficient package manager integrated with `$PNPM_HOME` |
| **Git Client** | [Lazygit](https://github.com/jesseduffield/lazygit) | High-productivity terminal UI for Git |
| **System Info** | [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | Responsive system fetch adapting layout to terminal window dimensions |
| **Cloud Mount** | [systemd (user)](https://www.freedesktop.org/software/systemd/man/systemd.service.html) | On-demand cloud storage mounting via `rclone@<remote>.service` |

---

## Display Server & Desktop Portability

This configuration suite is **100% desktop environment agnostic** and works identically across KDE Plasma, GNOME, Hyprland, Sway, and window managers:

- **Wayland & X11 Clipboard**: Tmux dynamically dispatches between `wl-copy` (when `$WAYLAND_DISPLAY` is present) and `xclip` (on X11), alongside OSC 52 clipboard passthrough (`set-clipboard on`).
- **Neovim Clipboard**: Configured with `opt.clipboard = "unnamedplus"`, automatically delegating to Wayland or X11 clipboard providers.
- **Zero DE Coupling**: No system-level desktop configurations or WM shortcuts are overridden.

---

## Post-Installation Verification Checklist

Confirm your environment is properly initialized:

- [ ] **Shell**: Run `zsh` $\rightarrow$ Fastfetch banner loads adaptively without missing glyphs.
- [ ] **Node & pnpm**: Run `node -v` and `pnpm -v` $\rightarrow$ Versions resolve via `fnm` and userland paths.
- [ ] **Tmux**: Launch `tmux`, press `Ctrl + Space` followed by `I` $\rightarrow$ Plugins clone and compile.
- [ ] **Neovim**: Run `nvim` $\rightarrow$ `lazy.nvim` installs plugins cleanly and Mason downloads language servers.
- [ ] **Symlinks Integrity**: Inspect `ls -ld ~/.config/nvim ~/.zshenv` $\rightarrow$ Links point directly to `~/.myconfigs`.

---

## File Structure Reference

For the comprehensive index mapping repository files to their target OS locations, inspect [**`structure.md`**](structure.md).
