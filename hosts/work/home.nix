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
    (
      { config, ... }:
      {
        infra.git = {
          signingKeyPath = config.sops.secrets."ssh_git_signing_key/work".path;
          allowedSignersFile = config.sops.templates."allowed_signers".path;
        };

        sops = {
          defaultSopsFile = "${secretsPath}/secrets/shared.yaml";
          age.keyFile = "${config.infra.host.homeDir}/Library/Application Support/sops/age/keys.txt";
          secrets."ssh_git_signing_key/work" = { };
          templates."allowed_signers".content = ''
            * ${config.sops.placeholder."ssh_git_signing_key/work"}
          '';
        };
      }
    )
  ]
  ++ [
    {
      infra.git = {
        userName = "Ivan Ilak";
        userEmail = "ivan.ilak@mxwbio.com";
      };
    }
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
