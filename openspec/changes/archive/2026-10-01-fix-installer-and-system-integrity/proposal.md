# Proposal: Fix Installer and System Integrity

## Intent

The current automated installer script (`install.sh`) and related configuration files suffer from critical architectural and execution bugs:
1. Tmux Plugin Manager (TPM) fails to clone because orphaned git submodule gitlinks (mode `160000`) leave empty directories in tracked files, causing `[ ! -d "$tpm_dir" ]` to evaluate false.
2. GNU `ln -sfn` creates nested symlinks (e.g. `~/.config/nvim/nvim`) when target directories already exist as physical directories without backup flags enabled.
3. Existing user environment files (such as `~/.zshenv` with Cargo/Rust settings) are destructively overwritten without preservation.
4. Hardcoded user paths (`/home/mr0rang3`) break portability across systems and user accounts.
5. Systemd unit `rclone@.service` contains a comment line inside a backslash continuation, injecting invalid arguments into `rclone mount`.
6. Distribution detection ignores `ID_LIKE`, and package lists lack parity (missing `lazygit`, `eza`, and font packages on Debian/Ubuntu derivatives).

This change establishes an idempotent, non-destructive, and portable installation lifecycle adhering to XDG standards.

## Scope

### In Scope
- Sane Git index handling for `config/tmux/plugins` (clean submodule gitlinks, update `.gitignore`, and robust clone verification).
- Robust symlink engine handling existing directory conflicts gracefully with safe backup.
- Non-destructive `~/.zshenv` deployment and dynamic path expansion in `config/zsh/.zshenv`.
- Syntax repair for `config/systemd/user/rclone@.service`.
- Multi-distro detection taking `ID_LIKE` into account and harmonizing core packages (`lazygit`, `eza`, Nerd Fonts).
- Shell check for default user shell (`$SHELL`) with guidance or option to set Zsh.

### Out of Scope
- Rewriting individual Neovim plugin configurations.
- Changing Tmux keybindings or visual themes.
- Adding support for non-Linux OSes (macOS/BSD).

## Capabilities

### New Capabilities
- `installer-lifecycle`: Fully automated, idempotent installer supporting `--dry-run`, `--backup`, `--symlinks-only`, and conflict detection.

### Modified Capabilities
- None

## Approach

1. **Git Submodule & TPM Clean-up**: Remove mode 160000 gitlinks from Git tracking for `config/tmux/plugins/*`, add `config/tmux/plugins/` to `.gitignore` (except a `.gitkeep` if desired), and update `install.sh` to check for the executable script (`[ -f "$tpm_dir/tpm" ]`) rather than directory existence alone.
2. **Safe Link Deployment (`ln` directory check)**: Before calling `ln -sfn`, inspect if target path exists and is a directory (not a symlink). If so, backup if `-b` is specified, or abort/prompt with clear guidance to prevent GNU `ln` nested link creation.
3. **Environment Portability**: Replace `/home/mr0rang3/.local/bin` with `"$HOME/.local/bin"` and ensure `$HOME/.cargo/bin` is in PATH in `config/zsh/.zshenv`. Preserves preexisting `~/.zshenv` contents by appending or sourcing.
4. **Systemd Unit Syntax Fix**: Remove the inline `#` commented line from within `ExecStart` multiline continuation in `config/systemd/user/rclone@.service`.
5. **Distribution Parity**: Enhance `detect_distro` to inspect `ID_LIKE` and add missing packages (`lazygit`, `eza`, `fonts-jetbrains-mono`) for Debian/Ubuntu families.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `install.sh` | Modified | Core installer logic, package list, link safety, TPM check |
| `.gitignore` | Modified | Ignore cloned tmux plugins and runtime artifacts |
| `config/tmux/plugins` | Modified | Remove orphaned 160000 gitlinks from git index |
| `config/zsh/.zshenv` | Modified | Parameterize home path, add cargo bin to path |
| `config/systemd/user/rclone@.service` | Modified | Fix broken multiline `ExecStart` syntax |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Clashing with user's existing configs | Medium | Strict backup routine (`-b` or automatic warning/prompt) prior to any link overwrite |
| Untracked git changes during plugin clone | Low | Ignore plugin directories in `.gitignore` |
| Package name differences across distros | Low | Verify package availability via distro package managers |

## Rollback Plan

All file modifications in the repository are tracked via Git. To revert:
```bash
git checkout HEAD -- install.sh config/zsh/.zshenv config/systemd/user/rclone@.service .gitignore
```
If symlinks were deployed, restore from the timestamped backup directory (`~/.config_backup_*`).

## Dependencies

- Git (>= 2.25)
- GNU Coreutils & Bash (>= 4.0)

## Success Criteria

- [ ] `bash -n install.sh` passes without syntax errors.
- [ ] `./install.sh --dry-run` executes cleanly on Debian/Ubuntu, Arch, and Fedora environments without warnings.
- [ ] Running `./install.sh -b` clones TPM into `config/tmux/plugins/tpm` if missing and does not skip due to empty folders.
- [ ] Existing non-symlink directories in `~/.config/` do not end up with nested symlinks inside them.
- [ ] `config/systemd/user/rclone@.service` passes `systemd-analyze verify`.
- [ ] No hardcoded `/home/mr0rang3` paths remain in `config/zsh/.zshenv`.
