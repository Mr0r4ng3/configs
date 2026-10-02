# Specification: Installer Lifecycle

## ADDED Requirements

### Requirement: Idempotent Plugin Bootstrapping
The installer MUST clone the Tmux Plugin Manager (TPM) if its main executable is missing, even if an empty directory exists from Git checkout.

#### Scenario: Cloned repository contains empty TPM directory
- **Given** a fresh clone of the dotfiles repository where `config/tmux/plugins/tpm` exists as an empty directory
- **When** `./install.sh` or `./install.sh -s` is executed
- **Then** the installer MUST detect that `tpm/tpm` executable is absent
- **And** it MUST clone TPM into `config/tmux/plugins/tpm` without throwing a directory collision error

#### Scenario: TPM is already cloned and operational
- **Given** `config/tmux/plugins/tpm/tpm` exists and is a valid file
- **When** `./install.sh` is executed
- **Then** the installer MUST report that TPM is already present
- **And** it MUST NOT re-clone or fail

---

### Requirement: Conflict-Safe Symlink Deployment
The installer MUST NOT create nested symlinks when linking into target directories, and MUST protect existing non-symlink configurations.

#### Scenario: Target directory already exists without backup flag
- **Given** an existing physical directory at `~/.config/nvim` that is NOT a symlink
- **When** `./install.sh` is executed without `--backup` (`-b`)
- **Then** the installer MUST NOT execute `ln -sfn` directly into the existing directory to create a nested symlink
- **And** it MUST prompt the user or warn and safely back up the conflicting directory before linking

#### Scenario: Target directory already exists with backup flag
- **Given** an existing physical directory or file at `~/.config/nvim`
- **When** `./install.sh -b` is executed
- **Then** the installer MUST move the existing target to a timestamped backup directory under `~/.config_backup_*`
- **And** it MUST create the symlink pointing to the repository configuration

---

### Requirement: Environment Preservation & Dynamic Paths
The configuration MUST NOT assume static usernames and MUST preserve existing user toolchain definitions in `~/.zshenv`.

#### Scenario: Existing Cargo/Rust environment in ~/.zshenv
- **Given** `~/.zshenv` already contains `. "$HOME/.cargo/env"` or other user exports
- **When** `install.sh` deploys `~/.zshenv`
- **Then** the installer MUST preserve the previous definitions or ensure Cargo environment sourcing is retained

#### Scenario: User-specific local bin PATH
- **Given** `config/zsh/.zshenv` sets user environment paths
- **When** the shell evaluates `.zshenv`
- **Then** the path MUST expand dynamically using `$HOME/.local/bin` instead of hardcoding any specific home directory

---

### Requirement: Valid Systemd User Unit Definitions
The systemd user service templates in the repository MUST conform to valid systemd unit file syntax.

#### Scenario: Parsing rclone@.service
- **Given** `config/systemd/user/rclone@.service`
- **When** systemd parses the `ExecStart` directive
- **Then** comments MUST NOT be embedded inside line continuations (`\`)
- **And** `systemd-analyze verify` MUST NOT report invalid arguments from commented flags
