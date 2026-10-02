# Tasks: Fix Installer and System Integrity

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~80-120 lines |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single commit / PR |
| Delivery strategy | single-pr |
| Chain strategy | single-branch |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: single-branch
400-line budget risk: Low

---

## Implementation Tasks

### Phase 1: Git Submodule & Repository Cleanup
- [x] 1.1 Remove mode 160000 gitlinks from index: `git rm --cached config/tmux/plugins/*`
- [x] 1.2 Update `.gitignore` to ignore `config/tmux/plugins/` (preserving directory structure if needed)

### Phase 2: Configuration Sanitization
- [x] 2.1 Sanitize `config/zsh/.zshenv`: replace hardcoded user path with `$HOME/.local/bin` and add `$HOME/.cargo/bin`
- [x] 2.2 Fix syntax in `config/systemd/user/rclone@.service`: eliminate embedded `#` comment line in multiline `ExecStart`

### Phase 3: Installer Logic Hardening (`install.sh`)
- [x] 3.1 Improve distro detection in `detect_distro()` to evaluate `DISTRO_ID_LIKE` for Debian, Arch, and Fedora derivatives
- [x] 3.2 Add missing packages in Debian/Ubuntu list: `lazygit`, `eza`, and `fonts-jetbrains-mono`
- [x] 3.3 Overhaul `deploy_symlinks()`: inspect target paths and safely backup conflicting physical directories before linking to prevent GNU `ln` nested directory links
- [x] 3.4 In `deploy_symlinks()`, preserve existing `~/.zshenv` contents (such as Cargo environment exports)
- [x] 3.5 Fix TPM bootstrap check in `bootstrap_toolchain()`: check for binary executable (`[ -f "$tpm_dir/tpm" ]`) instead of directory existence (`[ ! -d "$tpm_dir" ]`)

### Phase 4: Verification & Smoke Testing
- [x] 4.1 Validate bash syntax: `bash -n install.sh`
- [x] 4.2 Validate zsh syntax: `zsh -n config/zsh/*.zsh config/zsh/.zshenv .zshenv`
- [x] 4.3 Run dry-run execution: `./install.sh --dry-run`
- [x] 4.4 Verify git status and index clean state
