{
  inputs,
  ...
}:
{
  infra.fishUnstable.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.claude-code.overlays.default
    ];
  };
}
