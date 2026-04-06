{
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (inputs) nixvim;
  inherit (config.infra.host) homeDir;
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-modules.homeManagerModules.i3
    inputs.nix-modules.homeManagerModules.git
    inputs.nix-modules.homeManagerModules.lazygit
    inputs.nix-modules.homeManagerModules.rofi
    inputs.nix-modules.homeManagerModules.fish
    inputs.nix-modules.homeManagerModules.direnv
    inputs.nix-modules.homeManagerModules.alacritty
    inputs.nix-modules.homeManagerModules.fzf
    inputs.nix-modules.homeManagerModules.i3-status-rust
    inputs.nix-modules.homeManagerModules.polybar
    inputs.nix-modules.homeManagerModules.dunst
    inputs.nix-modules.homeManagerModules.ghostty
    inputs.nix-modules.homeManagerModules.helix
    inputs.nix-modules.homeManagerModules.infra-options
  ];

  targets.genericLinux = {
    enable = true;
    gpu.enable = true;
  };

  xsession = {
    enable = true;
  };

  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

  home = {
    packages = import ./packages.nix {
      inherit
        inputs
        pkgs
        nixvim
        ;
    };
    file = import ./files.nix { inherit inputs homeDir; };
    username = config.infra.host.user;
    homeDirectory = config.infra.host.homeDir;
  };

  infra.git = {
    userName = "Ivan Ilak";
    userEmail = "ivan.ilak@mxwbio.com";
    signingKeyPath = config.sops.secrets."ssh_git_signing_key/work".path;
    allowedSignersFile = config.sops.templates."allowed_signers".path;
    useAdWrapper = true;
  };

  sops = {
    defaultSopsFile = "${secretspath}/secrets/shared.yaml";
    age = {
      keyFile = "${homeDir}/.config/sops/age/keys.txt";
    };
    secrets = {
      "ssh_git_signing_key/work" = { };
      ssh_config = {
        sopsFile = "${secretspath}/secrets/mxw-dalco01/ssh_config";
        path = "${config.infra.host.homeDir}/.ssh/config";
        mode = "0600";
        format = "binary";
      };
    };
    templates."allowed_signers".content = ''
      * ${config.sops.placeholder."ssh_git_signing_key/work"}
    '';
  };

  catppuccin = {
    flavor = "mocha";
    enable = true;
    rofi.enable = false;
  };

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    alacritty.package = pkgs.alacritty;
  };

  home.stateVersion = "24.11";
}
