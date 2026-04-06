{
  description = "Work machine Nix configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-modules = {
      url = "github:i-ilak/nix-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:i-ilak/nixvim-config/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@git.ilak.ch/i-ilak/nix-secrets.git?shallow=1&ref=main";
      flake = false;
    };
    claude-code.url = "github:sadjow/claude-code-nix";
  };
  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      homeConfigurations = {
        mxw-dalco01 = import ./hosts/mxw-dalco01/home-manager.nix {
          inherit nixpkgs inputs;
        };
      };
    };
}
