# Project Structure & OS Target Mapping

Quick reference index mapping repository files to their target OS locations. Designed as a lightweight, low-token directory for users and AI assistants. For full setup instructions and system documentation, refer to [README.md](README.md).

---

## High-Level Mappings

| Repo Source | Target OS Path | Component |
| :--- | :--- | :--- |
| [`.zshenv`](.zshenv) | `~/.zshenv` | Zsh environment bootstrap (sets `ZDOTDIR`) |
| [`config/fastfetch/`](config/fastfetch) | `~/.config/fastfetch` | Fastfetch system information configuration |
| [`config/kitty/`](config/kitty) | `~/.config/kitty` | Kitty terminal emulator & color themes |
| [`config/lazygit/`](config/lazygit) | `~/.config/lazygit` | Lazygit TUI configuration |
| [`config/nvim/`](config/nvim) | `~/.config/nvim` | Neovim IDE configuration (`lazy.nvim`) |
| [`config/systemd/user/`](config/systemd/user) | `~/.config/systemd/user` | User-level systemd services |
| [`config/tmux/`](config/tmux) | `~/.config/tmux` | Tmux multiplexer config & plugins |
| [`config/zsh/`](config/zsh) | `~/.config/zsh` | Modular Zsh shell configuration |

---

## Detailed File Index

### 1. Root & Deployment

| File | Target OS Path | Purpose |
| :--- | :--- | :--- |
| [`.zshenv`](.zshenv) | `~/.zshenv` | Root environment bootstrap: sets `ZDOTDIR="$HOME/.config/zsh"` |
| [`install.sh`](install.sh) | N/A (Repository) | Automated idempotent installer and symlink deployment script |
| [`README.md`](README.md) | N/A (Repository) | Main human documentation and user guide |
| [`structure.md`](structure.md) | N/A (Repository) | Lightweight structural index and OS mapping directory |
| [`.gitignore`](.gitignore) | N/A (Repository) | Git ignore rules for temporary files and local overrides |

### 2. Shell Bootstrap & Zsh (`~/.config/zsh`)

| File | Target OS Path | Purpose |
| :--- | :--- | :--- |
| [`config/zsh/.zshenv`](config/zsh/.zshenv) | `~/.config/zsh/.zshenv` | XDG base directories and early environment exports |
| [`config/zsh/.zshrc`](config/zsh/.zshrc) | `~/.config/zsh/.zshrc` | Interactive shell entrypoint; loads modular zsh scripts |
| [`config/zsh/aliases.zsh`](config/zsh/aliases.zsh) | `~/.config/zsh/aliases.zsh` | Command aliases and shortcuts |
| [`config/zsh/completion.zsh`](config/zsh/completion.zsh) | `~/.config/zsh/completion.zsh` | Completion menu, styles, and caching options |
| [`config/zsh/env.zsh`](config/zsh/env.zsh) | `~/.config/zsh/env.zsh` | Shell session environment variables |
| [`config/zsh/fastfetch.zsh`](config/zsh/fastfetch.zsh) | `~/.config/zsh/fastfetch.zsh` | Responsive Fastfetch startup hook with size adaptation |
| [`config/zsh/functions.zsh`](config/zsh/functions.zsh) | `~/.config/zsh/functions.zsh` | Custom utility functions |
| [`config/zsh/history.zsh`](config/zsh/history.zsh) | `~/.config/zsh/history.zsh` | History file size and behavior rules |
| [`config/zsh/keybindings.zsh`](config/zsh/keybindings.zsh) | `~/.config/zsh/keybindings.zsh` | ZLE keybindings and keyboard shortcuts |
| [`config/zsh/options.zsh`](config/zsh/options.zsh) | `~/.config/zsh/options.zsh` | Shell behavior flags (`setopt`/`unsetopt`) |

### 3. Neovim Editor (`~/.config/nvim`)

| File | Target OS Path | Purpose |
| :--- | :--- | :--- |
| [`config/nvim/init.lua`](config/nvim/init.lua) | `~/.config/nvim/init.lua` | Neovim root entrypoint |
| [`config/nvim/lazy-lock.json`](config/nvim/lazy-lock.json) | `~/.config/nvim/lazy-lock.json` | Plugin version lockfile |
| [`config/nvim/lua/config/keymaps.lua`](config/nvim/lua/config/keymaps.lua) | `~/.config/nvim/lua/config/keymaps.lua` | Global editor keymaps |
| [`config/nvim/lua/config/lazy.lua`](config/nvim/lua/config/lazy.lua) | `~/.config/nvim/lua/config/lazy.lua` | `lazy.nvim` plugin manager bootstrap |
| [`config/nvim/lua/config/options.lua`](config/nvim/lua/config/options.lua) | `~/.config/nvim/lua/config/options.lua` | General editor options (tabs, numbers, clipboard) |
| [`config/nvim/lua/plugins/autopairs.lua`](config/nvim/lua/plugins/autopairs.lua) | `~/.config/nvim/lua/plugins/autopairs.lua` | Auto-closing brackets plugin (`nvim-autopairs`) |
| [`config/nvim/lua/plugins/colorscheme.lua`](config/nvim/lua/plugins/colorscheme.lua) | `~/.config/nvim/lua/plugins/colorscheme.lua` | Editor theme configuration |
| [`config/nvim/lua/plugins/completion.lua`](config/nvim/lua/plugins/completion.lua) | `~/.config/nvim/lua/plugins/completion.lua` | Completion engine and sources |
| [`config/nvim/lua/plugins/formatting.lua`](config/nvim/lua/plugins/formatting.lua) | `~/.config/nvim/lua/plugins/formatting.lua` | Code formatting configuration |
| [`config/nvim/lua/plugins/gitsigns.lua`](config/nvim/lua/plugins/gitsigns.lua) | `~/.config/nvim/lua/plugins/gitsigns.lua` | Git diff indicators in gutter |
| [`config/nvim/lua/plugins/lsp.lua`](config/nvim/lua/plugins/lsp.lua) | `~/.config/nvim/lua/plugins/lsp.lua` | LSP configuration and language servers |
| [`config/nvim/lua/plugins/lualine.lua`](config/nvim/lua/plugins/lualine.lua) | `~/.config/nvim/lua/plugins/lualine.lua` | Statusline appearance and components |
| [`config/nvim/lua/plugins/oil.lua`](config/nvim/lua/plugins/oil.lua) | `~/.config/nvim/lua/plugins/oil.lua` | File explorer (`oil.nvim`) |
| [`config/nvim/lua/plugins/snacks.lua`](config/nvim/lua/plugins/snacks.lua) | `~/.config/nvim/lua/plugins/snacks.lua` | QoL utilities and picker (`snacks.nvim`) |
| [`config/nvim/lua/plugins/treesitter.lua`](config/nvim/lua/plugins/treesitter.lua) | `~/.config/nvim/lua/plugins/treesitter.lua` | Syntax parsing and highlighting |
| [`config/nvim/lua/plugins/which-key.lua`](config/nvim/lua/plugins/which-key.lua) | `~/.config/nvim/lua/plugins/which-key.lua` | Keybinding helper popup |

### 4. Terminal & Multiplexer

| File | Target OS Path | Purpose |
| :--- | :--- | :--- |
| [`config/kitty/kitty.conf`](config/kitty/kitty.conf) | `~/.config/kitty/kitty.conf` | Kitty terminal configuration |
| [`config/kitty/themes/noctalia.conf`](config/kitty/themes/noctalia.conf) | `~/.config/kitty/themes/noctalia.conf` | Kitty Noctalia color theme |
| [`config/kitty/themes/nord.conf`](config/kitty/themes/nord.conf) | `~/.config/kitty/themes/nord.conf` | Kitty Nord color theme |
| [`config/tmux/tmux.conf`](config/tmux/tmux.conf) | `~/.config/tmux/tmux.conf` | Tmux multiplexer configuration |
| [`config/tmux/plugins/`](config/tmux/plugins/) | `~/.config/tmux/plugins/` | Tmux Plugin Manager (TPM) plugins directory |

### 5. Utilities & Systemd

| File | Target OS Path | Purpose |
| :--- | :--- | :--- |
| [`config/fastfetch/config.jsonc`](config/fastfetch/config.jsonc) | `~/.config/fastfetch/config.jsonc` | Fastfetch layout, modules, and theme styling |
| [`config/lazygit/config.yml`](config/lazygit/config.yml) | `~/.config/lazygit/config.yml` | Lazygit TUI options and keybindings |
| [`config/systemd/user/rclone@.service`](config/systemd/user/rclone@.service) | `~/.config/systemd/user/rclone@.service` | Systemd user template unit for rclone mounts |
