# work-nix-config

Nix configurations for work machines.

## Hosts

| Host | Platform | Type | Purpose |
|------|----------|------|---------|
| `work` | aarch64-darwin | nix-darwin | Work macOS laptop |

## Bootstrap

On a fresh macOS machine:

```bash
curl -fsSL https://raw.githubusercontent.com/i-ilak/work-nix-config/main/bootstrap.sh | bash -s -- work
```

Or from a cloned repo:

```bash
./bootstrap.sh work
```

This installs Xcode CLI tools, Nix (Determinate), clones the repo, and runs the first `darwin-rebuild switch`.

## Usage

```bash
# Apply configuration
just switch

# Or explicitly
just darwin-switch

# Evaluate without building
just eval-darwin

# Update all flake inputs
just update
```

## Dependencies

- [nix-modules](https://github.com/i-ilak/nix-modules) (public) — reusable HM/darwin modules and infra option declarations
- nix-secrets (private, optional) — git signing keys via sops-nix

## Secrets (optional)

Git commit signing is disabled by default. To enable it:

1. Generate an age key:
   ```bash
   mkdir -p ~/Library/Application\ Support/sops/age
   age-keygen -o ~/Library/Application\ Support/sops/age/keys.txt
   ```
2. Set up a `nix-secrets` directory with `.sops.yaml` and encrypted secrets
3. Uncomment `secretsPath` in `flake.nix`
4. Run `just switch`
