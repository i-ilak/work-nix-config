# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Work machine Nix configurations, separated from personal infrastructure. Uses standalone home-manager (not NixOS) on company-managed Linux workstations. Reusable modules are consumed from the public [nix-modules](https://github.com/i-ilak/nix-modules) flake input.

## Commands

```bash
# Apply configuration (home-manager switch)
home-manager switch --flake .#mxw-dalco01

# Lint Nix code
nix run nixpkgs#statix -- check .

# Find dead/unused Nix code
nix run nixpkgs#deadnix -- .

# Evaluate without building
nix eval .#homeConfigurations.mxw-dalco01.activationPackage.drvPath
```

## Architecture

### Hosts

| Host | Platform | Type | Purpose |
|------|----------|------|---------|
| `mxw-dalco01` | x86_64-linux | home-manager only | Work Linux workstation (non-NixOS, AD-managed user) |

### Key Dependencies

- **nix-modules** (public) — all HM modules (git, fish, i3, helix, ghostty, etc.) and infra option declarations
- **nix-secrets** (private) — git signing keys and SSH config via sops-nix
- **catppuccin** — theming
- **nixvim** — editor configuration
- **claude-code** — nixpkgs overlay for Claude Code package

### Per-Host Structure (`hosts/mxw-dalco01/`)

- `home-manager.nix` — entry point, creates `homeManagerConfiguration`
- `home.nix` — main config: module imports, sops wiring, git config, packages, dotfiles
- `additional_config_parameters.nix` — sets `infra.host` and `infra.desktop` values
- `packages.nix` — GUI apps, dev tools, fonts, shared packages from nix-modules
- `files.nix` — dotfile symlinks (ccache, ideavimrc, vimrc, vscode settings from nix-modules)

### Key Patterns

- Git is wrapped with `LD_PRELOAD` for AD/NSS user ID resolution (`infra.git.useAdWrapper = true`)
- CLion is similarly wrapped with `LD_PRELOAD` for the same reason
- Dotfiles and scripts come from nix-modules via `inputs.nix-modules` paths
- No personal infrastructure values — work email is set directly, not via `personal_values.nix`
- Secrets (git signing key, SSH config) still come from nix-secrets via sops-nix with age key at `~/.config/sops/age/keys.txt`
