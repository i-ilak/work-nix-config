{
  inputs,
  secretsPath ? null,
}:
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs secretsPath; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.determinate.darwinModules.default
    inputs.nix-modules.darwinModules.nix-homebrew-base
    (
      _: {
        infra.nixHomebrew = {
          enable = true;
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
            "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
          };
        };
      }
    )
    ./macbook.nix
  ];
}
