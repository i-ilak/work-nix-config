# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Work macOS nix-darwin configuration, separated from personal infrastructure. Reusable modules are consumed from the public [nix-modules](https://github.com/i-ilak/nix-modules) flake input.

## Commands

```bash
# Apply configuration (auto-detects OS and hostname via nh)
just switch

# Or explicitly
just darwin-switch

# Garbage collect old generations
just clean

# Lint Nix code
just lint

# Find dead/unused Nix code
just deadnix

# Evaluate without building
just eval-darwin

# Bootstrap a fresh macOS machine
./bootstrap.sh work
```

## Architecture

### Hosts

| Host | Platform | Type | Purpose |
|------|----------|------|---------|
| `work` | aarch64-darwin | nix-darwin | Work macOS laptop (determinate nix, nix-homebrew) |

### Key Dependencies

- **nix-modules** (public) — all HM and darwin modules (git, fish, helix, ghostty, system settings, dock, homebrew, etc.) and infra option declarations
- **darwin** (nix-darwin) — macOS system management
- **nix-homebrew** — declarative Homebrew management
- **determinate** — Determinate Nix settings
- **sops-nix** — secret management (optional, gated behind `secretsPath`)
- **catppuccin** — theming
- **nixvim** — editor configuration
- **claude-code** — nixpkgs overlay for Claude Code package

### Per-Host Structure (`hosts/work/`)

- `nix-darwin.nix` — entry point, creates `darwinSystem`, accepts optional `secretsPath`
- `macbook.nix` — main darwin config: imports, homebrew, fonts, nix settings
- `home.nix` — home-manager config: module imports, conditional sops wiring, git config, packages
- `additional_config_parameters.nix` — sets `infra.host` and `infra.desktop` values
- `packages.nix` — dev tools, shared packages from nix-modules

### Key Patterns

- Secrets are optional: pass `secretsPath = "/path/to/nix-secrets"` in `flake.nix` to enable sops-nix git signing. When `null` (default), the flake evaluates and builds without any secrets setup.
- No personal infrastructure values — work email is set directly in `home.nix`
- Fish from nixpkgs-unstable as a workaround for aarch64-darwin code signature bug
- Modules and shared packages come from nix-modules via `inputs.nix-modules` paths
