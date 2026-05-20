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
    ./overlays.nix
    ./nix-settings.nix
    ./fonts.nix
    ./user.nix
    inputs.nix-modules.darwinModules.infra-options
    inputs.nix-modules.darwinModules.homebrew
    inputs.nix-modules.darwinModules.dock
    (inputs.nix-modules.darwinModules.fish-unstable { inherit (inputs) nixpkgs-unstable; })
  ];

  environment.systemPackages = import "${inputs.nix-modules}/modules/shared/system_packages.nix" {
    inherit pkgs;
  };

  # Clear the dock on activation; entries left intentionally empty.
  local.dock = {
    enable = true;
    entries = [ ];
    username = "${user}";
  };
}
