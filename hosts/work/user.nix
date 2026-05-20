{
  pkgs,
  inputs,
  config,
  secretsPath,
  ...
}:
let
  inherit (config.infra.host) user;
in
{
  ids.gids.nixbld = 350;

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = import ./home.nix {
      inherit
        pkgs
        inputs
        config
        secretsPath
        ;
      inherit (pkgs) lib;
    };
  };

  programs.fish.enable = true;
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = import "${inputs.nix-modules}/modules/darwin/system.nix" { inherit config; };
}
