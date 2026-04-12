#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/i-ilak/work-nix-config.git"
REPO_DIR="$HOME/work-nix-config"
FLAKE_ATTR="work"

log()  { printf '\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m==> %s\033[0m\n' "$*"; }

# --- Phase 1: Xcode Command Line Tools ---
log "Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  log "Installing Xcode Command Line Tools (follow the GUI prompt)..."
  xcode-select --install
  echo "Press Enter once the installation finishes."
  read -r
else
  ok "Xcode CLI tools already installed."
fi

# --- Phase 2: Install Nix ---
log "Checking for Nix..."
if ! command -v nix &>/dev/null; then
  log "Installing Nix (Determinate installer)..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

  # Source nix-daemon so nix is available in this shell
  if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
else
  ok "Nix already installed."
fi

# Verify nix is on PATH
if ! command -v nix &>/dev/null; then
  echo "ERROR: nix not found on PATH after installation. Open a new terminal and re-run." >&2
  exit 1
fi

# --- Phase 3: Clone repository ---
log "Checking for config repository..."
# Detect if we're already inside the repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/flake.nix" ]; then
  REPO_DIR="$SCRIPT_DIR"
  ok "Running from inside the repository at $REPO_DIR"
elif [ -d "$REPO_DIR" ] && [ -f "$REPO_DIR/flake.nix" ]; then
  ok "Repository already cloned at $REPO_DIR"
else
  log "Cloning $REPO_URL to $REPO_DIR..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

# --- Phase 4: Fix known system conflicts ---
log "Checking for system conflicts..."
if [ -f /etc/nix/nix.custom.conf ] && [ ! -L /etc/nix/nix.custom.conf ]; then
  warn "Removing /etc/nix/nix.custom.conf (conflicts with nix-darwin)..."
  sudo rm /etc/nix/nix.custom.conf
else
  ok "No system conflicts found."
fi

# --- Phase 5: First nix-darwin switch ---
log "Running first nix-darwin switch..."
cd "$REPO_DIR"
nix run nix-darwin -- switch --flake ".#${FLAKE_ATTR}"

# --- Done ---
ok "Bootstrap complete!"
echo ""
echo "Your system is configured. To apply future changes:"
echo "  cd $REPO_DIR && just switch"
echo ""
echo "--- Optional: Set up commit signing with sops-nix ---"
echo ""
echo "1. Generate an age key:"
echo "   mkdir -p ~/Library/Application\\ Support/sops/age"
echo "   age-keygen -o ~/Library/Application\\ Support/sops/age/keys.txt"
echo ""
echo "2. Create your nix-secrets directory:"
echo "   mkdir -p ~/nix-secrets/secrets"
echo ""
echo "3. Add your age public key to ~/nix-secrets/.sops.yaml:"
echo "   keys:"
echo "     - &work age1YOUR_PUBLIC_KEY_HERE"
echo "   creation_rules:"
echo "     - path_regex: secrets/shared\\.yaml\$"
echo "       key_groups:"
echo "         - age:"
echo "             - *work"
echo ""
echo "4. Create and encrypt the secrets file:"
echo "   sops ~/nix-secrets/secrets/shared.yaml"
echo "   # Add: ssh_git_signing_key:"
echo "   #        work: ssh-ed25519 AAAA..."
echo ""
echo "5. Enable secrets in $REPO_DIR/hosts/work/additional_config_parameters.nix:"
echo "   local.enableSecrets = true;"
echo ""
echo "6. Point nix-secrets to your real secrets and re-apply:"
echo "   cd $REPO_DIR"
echo "   nix flake update nix-secrets --override-input nix-secrets path:~/nix-secrets"
echo "   just switch"
