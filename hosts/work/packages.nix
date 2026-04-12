{
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) nixvim;
  sharedPackages = import "${inputs.nix-modules}/modules/home-manager/shared_packages.nix" {
    inherit pkgs nixvim inputs;
    flakeRoot = inputs.nix-modules;
  };

  packages =
    with pkgs;
    [
      age
      sops
      dockutil
      docker
      claude-code
      nodejs_22
      nh
    ]
    ++ sharedPackages;
in
packages
