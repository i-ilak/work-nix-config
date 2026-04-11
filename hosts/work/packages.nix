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
      claude-code
      nodejs_22
      nh
      meslo-lgs-nf
      nerd-fonts.jetbrains-mono
    ]
    ++ sharedPackages;
in
packages
