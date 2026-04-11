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

  customClionPackage =
    let
      inherit (pkgs.jetbrains) clion;
    in
    pkgs.writeScriptBin "clion" ''
      #!${pkgs.bash}/bin/bash
      export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnss_sss.so.2"
      exec "${clion}/bin/clion" "$@"
    '';

  guiApplications = with pkgs; [
    keepassxc
    thunderbird
    dmenu
    mupdf
    p7zip
    colordiff
    nitrogen
    customClionPackage
    gimp
  ];

  developmentPackages = with pkgs; [
    awscli2
    ranger
    ccache
    doxygen
    flameshot
    claude-code
    nodejs_22 # Required by claude-code hooks (spawns node via /bin/sh)
    nh
    # Needed for fish plugin
    grc
  ];

  fonts = with pkgs; [
    meslo-lgs-nf
    udev-gothic-nf
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  packages = guiApplications ++ developmentPackages ++ fonts ++ sharedPackages;
in
packages
