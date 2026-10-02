# Design: Fix Installer and System Integrity

## Technical Approach

To achieve an idempotent, zero-data-loss installation workflow, this design addresses the root architectural defects across five critical domains:
1. **Git Submodule State**: Strip orphaned `160000` gitlinks from `config/tmux/plugins` in the Git index, add `plugins/` to `.gitignore`, and verify TPM presence by binary check (`[ -f "$tpm_dir/tpm" ]`) rather than directory existence alone.
2. **Symlink Engine & Conflict Resolution**: Re-architect `deploy_symlinks` in `install.sh` to distinguish between symlinks, regular files, and real directories. When a non-symlink directory exists at the destination, back it up if requested, or warn and safely create a backup before replacing, preventing GNU `ln` from generating nested directory links (`~/.config/nvim/nvim`).
3. **Environment & PATH Portability**: Parameterize `/home/mr0rang3` into `$HOME` across all shell configurations, add `$HOME/.cargo/bin` to the PATH array, and ensure existing `~/.zshenv` files preserve preexisting configurations when installing.
4. **Systemd Unit Syntax**: Sanitize `config/systemd/user/rclone@.service` by removing the commented line from inside the backslash continuation block.
5. **Distribution Discovery & Package Harmonization**: Extend distro detection to check `ID_LIKE` (supporting Pop!_OS, Linux Mint, EndeavourOS, etc.) and include `lazygit`, `eza`, and `fonts-jetbrains-mono` in Debian/Ubuntu packages.

---

## Architecture Decisions

### Decision 1: Git Plugin Submodule Untracking vs `.gitmodules`
- **Choice**: Remove mode 160000 gitlinks from Git tracking using `git rm --cached config/tmux/plugins/*`, keep `config/tmux/plugins/` in `.gitignore` (with a `.gitkeep` if desired), and let `install.sh` handle cloning TPM cleanly.
- **Alternatives considered**:
  1. Creating a `.gitmodules` file registering 5 submodules. (Rejected: adds heavy Git submodule friction for dotfiles users and breaks when submodules go offline).
  2. Leaving gitlinks as-is. (Rejected: git clones leave empty folders, breaking the installer's existence check).
- **Rationale**: Dotfiles repos should manage TPM as a bootstrapped toolchain rather than gitlinks that pollute the main repository index.

### Decision 2: GNU `ln` Conflict Handling Strategy
- **Choice**: In `deploy_symlinks()`, before invoking `ln -sfn`, inspect the target. If target exists and is a directory (and `! -L`):
  ```bash
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    # Must move/backup existing directory to avoid nested symlink
    backup_or_replace "$target"
  fi
  ```
- **Alternatives considered**:
  1. `rm -rf "$target"` blindly. (Rejected: destructive, risks deleting user's existing Neovim or Zsh configurations).
  2. Standard `ln -sfn` without check. (Rejected: GNU coreutils `ln` places symlink inside the folder if it's an existing directory).
- **Rationale**: Preserves user data while guaranteeing the target link points to the dotfiles repository.

### Decision 3: Shell Path Normalization
- **Choice**: Use `$HOME` parameter expansion in `config/zsh/.zshenv` and include `$HOME/.cargo/bin` in the path array. Also, if `~/.zshenv` exists, ensure `install.sh` backups or preserves lines like `. "$HOME/.cargo/env"`.
- **Alternatives considered**:
  1. Hardcoding paths. (Rejected: non-portable).
- **Rationale**: Dotfiles must be machine- and user-agnostic.

### Decision 4: Systemd Service Continuation Fix
- **Choice**: Move or delete `#    --allow-other \` from inside the `ExecStart` continuation line in `config/systemd/user/rclone@.service`.
- **Alternatives considered**:
  1. Un-commenting `--allow-other`. (Rejected: requires `user_allow_other` in `/etc/fuse.conf`, which might fail if not configured).
- **Rationale**: Systemd parses `#` after `\` as literal arguments. Removing it preserves default secure mounting without parse errors.

---

## File Changes

| File | Change | Description |
|------|--------|-------------|
| `install.sh` | Modify | Fix package lists, add `ID_LIKE` logic, fix `deploy_symlinks` conflict handling, fix TPM detection logic |
| `config/zsh/.zshenv` | Modify | Change `/home/mr0rang3/.local/bin` to `$HOME/.local/bin`, add `$HOME/.cargo/bin` |
| `config/systemd/user/rclone@.service` | Modify | Remove commented line within multiline `ExecStart` |
| `.gitignore` | Modify | Add `config/tmux/plugins/*` except `.gitkeep` |

---

## Verification Plan

1. **Syntax Checks**:
   - `bash -n install.sh`
   - `zsh -n config/zsh/*.zsh config/zsh/.zshenv .zshenv`
2. **Dry Run & Flag Testing**:
   - `./install.sh --dry-run`
   - `./install.sh --help`
3. **Idempotency & Symlink Integrity**:
   - Simulate existing directory in a temp target and verify no nested directory symlink is generated.
   - Verify TPM clone triggers when executable is missing.
