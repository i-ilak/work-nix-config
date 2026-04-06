# work-nix-config

Nix configurations for work machines. Uses standalone home-manager on company-managed Linux workstations.

## Hosts

| Host | Platform | Type | Purpose |
|------|----------|------|---------|
| `mxw-dalco01` | x86_64-linux | home-manager | Work Linux workstation (non-NixOS, AD-managed) |

## Usage

```bash
# Apply configuration
home-manager switch --flake .#mxw-dalco01

# Evaluate without building
nix eval .#homeConfigurations.mxw-dalco01.activationPackage.drvPath
```

## Dependencies

- [nix-modules](https://github.com/i-ilak/nix-modules) (public) — reusable HM modules and infra option declarations
- nix-secrets (private) — git signing keys and SSH config via sops-nix

## Adding a New Host

1. Create `hosts/<hostname>/` with:
   - `home-manager.nix` — entry point
   - `home.nix` — module imports and config
   - `additional_config_parameters.nix` — `infra.host` and `infra.desktop` values
   - `packages.nix` — host-specific packages
   - `files.nix` — dotfile symlinks
2. Add to `flake.nix` under `homeConfigurations` (or `darwinConfigurations` for macOS)
