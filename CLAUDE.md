# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Work machine Nix configurations, separated from personal infrastructure. Uses standalone home-manager (not NixOS) on company-managed Linux workstations. Reusable modules are consumed from the public [nix-modules](https://github.com/i-ilak/nix-modules) flake input.

## Commands

```bash
# Apply configuration locally (auto-detects OS and hostname via nh)
just switch

# Or explicitly per host type:
just hm-switch        # home-manager (Linux)
just darwin-switch    # nix-darwin (macOS)

# Garbage collect old generations
just clean

# Lint Nix code
nix run nixpkgs#statix -- check .

# Find dead/unused Nix code
nix run nixpkgs#deadnix -- .

# Evaluate without building
nix eval .#homeConfigurations.mxw-dalco01.activationPackage.drvPath
nix eval .#darwinConfigurations.work.system.drvPath
```

## Architecture

### Hosts

| Host | Platform | Type | Purpose |
|------|----------|------|---------|
| `mxw-dalco01` | x86_64-linux | home-manager only | Work Linux workstation (non-NixOS, AD-managed user) |
| `work` | aarch64-darwin | nix-darwin | Work macOS laptop (determinate nix, nix-homebrew) |

### Key Dependencies

- **nix-modules** (public) — all HM and darwin modules (git, fish, helix, system settings, dock, homebrew, etc.) and infra option declarations
- **darwin** (nix-darwin) — macOS system management
- **nix-homebrew** — declarative Homebrew management
- **determinate** — Determinate Nix settings
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
