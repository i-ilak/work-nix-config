{
  inputs,
  secretsPath ? null,
}:
let
  flakeRoot = inputs.self;
in
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs flakeRoot secretsPath; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.determinate.darwinModules.default
    (
      { config, ... }:
      {
        nix-homebrew = {
          enable = true;
          inherit (config.infra.host) user;
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
            "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
          };
          mutableTaps = false;
          autoMigrate = true;
        };
      }
    )
    ./macbook.nix
  ];
}
