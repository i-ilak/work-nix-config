{
  config,
  ...
}:
let
  inherit (config.infra.host) user;
in
{
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

  # Determinate Nix owns the daemon; disable nix-darwin's nix module to avoid conflicts.
  nix.enable = false;
}
