{
  pkgs,
  lib,
  inputs,
  secretsPath,
  ...
}:
let
  enableSecrets = secretsPath != null;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./additional_config_parameters.nix
    inputs.nix-modules.homeManagerModules.git
    inputs.nix-modules.homeManagerModules.lazygit
    inputs.nix-modules.homeManagerModules.fzf
    inputs.nix-modules.homeManagerModules.fish
    inputs.nix-modules.homeManagerModules.direnv
    inputs.nix-modules.homeManagerModules.helix
    inputs.nix-modules.homeManagerModules.ghostty
    inputs.nix-modules.homeManagerModules.infra-options
  ]
  ++ lib.optionals enableSecrets [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-modules.homeManagerModules.git-sops-signing
    {
      infra.gitSopsSigning = {
        enable = true;
        sopsFile = "${secretsPath}/secrets/shared.yaml";
        secretName = "ssh_git_signing_key/work";
      };
    }
  ]
  ++ [
    (
      { config, ... }:
      {
        infra.git = {
          userName = "Ivan Ilak";
          userEmail = config.infra.emails.work;
        };
      }
    )
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { inherit inputs; };
    stateVersion = "25.11";
  };

  catppuccin = {
    flavor = "mocha";
    enable = true;
    nvim.enable = false;
  };
}
