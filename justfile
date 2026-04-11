# Apply configuration locally (auto-detects OS and hostname)
switch:
    #!/usr/bin/env bash
    if [[ "$(uname)" == "Darwin" ]]; then
        nh darwin switch .
    else
        nh home switch .
    fi

# Apply home-manager configuration for Linux hosts
hm-switch host="mxw-dalco01":
    nh home switch . -c {{host}}

# Apply darwin configuration for macOS hosts
darwin-switch host="work":
    nh darwin switch . -H {{host}}

# Garbage collect old generations
clean:
    nh clean all

# Format all Nix files
fmt:
    nix --extra-experimental-features 'nix-command flakes' fmt

# Lint Nix code with statix
lint:
    nix --extra-experimental-features 'nix-command flakes' run nixpkgs#statix -- check .

# Find dead/unused Nix code
deadnix:
    nix --extra-experimental-features 'nix-command flakes' run nixpkgs#deadnix -- .

# Evaluate home-manager configuration (dry-run)
eval-hm host="mxw-dalco01":
    nix --extra-experimental-features 'nix-command flakes' eval .#homeConfigurations.{{host}}.activationPackage.drvPath

# Evaluate darwin configuration (dry-run)
eval-darwin host="work":
    nix --extra-experimental-features 'nix-command flakes' eval .#darwinConfigurations.{{host}}.system.drvPath

# Update all flake inputs
update:
    nix --extra-experimental-features 'nix-command flakes' flake update

# Update a single flake input
update-input input:
    nix --extra-experimental-features 'nix-command flakes' flake update {{input}}

# List all available hosts
hosts:
    @echo "Darwin:       work"
    @echo "Home-manager: mxw-dalco01"
