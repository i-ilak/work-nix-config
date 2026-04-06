{
  inputs,
  homeDir,
  ...
}:
let
  xdg_configHome = "${homeDir}/.config";
  flakeRoot = inputs.nix-modules;

  file = {
    "${xdg_configHome}/ccache/ccache.conf".source = flakeRoot + /dotfiles/linux/ccache/ccache.conf;
    "${homeDir}/.ideavimrc".source = flakeRoot + /dotfiles/shared/ideavimrc;
    "${homeDir}/.vimrc".source = flakeRoot + /dotfiles/shared/vimrc;
    "${xdg_configHome}/Code/User/settings.json".source =
      flakeRoot + /dotfiles/shared/vscode_user_settings.json;
    "${xdg_configHome}/Code/User/keybindings.json".source =
      flakeRoot + /dotfiles/shared/vscode_keybindings.json;
  };
in
file
