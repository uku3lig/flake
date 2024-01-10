{
  lib,
  pkgs,
  ...
}: {
  hm.programs.alacritty = let
    theme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/alacritty/ce476fb41f307d90f841c1a4fd7f0727c21248b2/catppuccin-macchiato.toml";
      hash = "sha256-m0Y8OBD9Pgjw9ARwjeD8a+JIQRDboVVCywQS8/ZBAcc=";
    };

    themeAttr = builtins.fromTOML (builtins.readFile theme);
  in {
    enable = true;
    settings = lib.recursiveUpdate themeAttr {
      font = {
        normal.family = "Iosevka Nerd Font";
        size = 12;
      };
    };
  };
}
