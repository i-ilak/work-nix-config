{
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.infra.host) user;
in
{
  imports = [
    ./additional_config_parameters.nix
    inputs.nix-modules.darwinModules.infra-options
    inputs.nix-modules.darwinModules.homebrew
    inputs.nix-modules.darwinModules.dock
  ];

  ids.gids.nixbld = 350;

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = import ./home.nix {
      inherit
        pkgs
        inputs
        config
        ;
    };
  };

  programs.fish.enable = true;
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.claude-code.overlays.default ];
  };

  determinateNix = {
    enable = true;
    customSettings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      eval-cores = 2;
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  nix.enable = false;

  environment.systemPackages = import "${inputs.nix-modules}/modules/shared/system_packages.nix" {
    inherit pkgs;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system = import "${inputs.nix-modules}/modules/darwin/system.nix" { inherit config; };

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
  ];

  local.dock = {
    enable = true;
    entries = [ ];
    username = "${user}";
  };
}
