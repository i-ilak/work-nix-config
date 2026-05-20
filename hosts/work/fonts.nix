{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
  ];
}
