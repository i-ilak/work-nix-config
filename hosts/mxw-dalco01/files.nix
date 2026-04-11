{
  inputs,
  homeDir,
  ...
}:
let
  xdg_configHome = "${homeDir}/.config";
  flakeRoot = inputs.nix-modules;
  vimLib = inputs.nix-modules.lib.vim;

  file = {
    "${xdg_configHome}/ccache/ccache.conf".source = flakeRoot + /dotfiles/linux/ccache/ccache.conf;
    "${homeDir}/.ideavimrc".text = vimLib.generateIdeavimrc { };
    "${homeDir}/.vimrc".text = vimLib.generateVimrc { };
    "${xdg_configHome}/Code/User/settings.json".text = builtins.toJSON (
      vimLib.generateVscodeSettings { }
    );
    "${xdg_configHome}/Code/User/keybindings.json".text = builtins.toJSON (
      vimLib.generateVscodeKeybindings { }
    );
  };
in
file
