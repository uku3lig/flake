{
  lib,
  pkgs,
  ...
}:
{
  hm.programs.alacritty =
    let
      theme = pkgs.fetchurl {
        # url = "https://raw.githubusercontent.com/catppuccin/alacritty/ce476fb41f307d90f841c1a4fd7f0727c21248b2/catppuccin-macchiato.toml";
        url = "https://raw.githubusercontent.com/rose-pine/alacritty/3c3e36eb5225b0eb6f1aa989f9d9e783a5b47a83/dist/rose-pine.toml";
        hash = "sha256-MheSmzz02ZLAOS2uaclyazu6E//eikcdFydFfkio0/U=";
      };

      themeAttr = builtins.fromTOML (builtins.readFile theme);
    in
    {
      enable = true;
      settings = lib.recursiveUpdate themeAttr {
        font = {
          normal.family = "Iosevka Nerd Font";
          size = 12;
        };
      };
    };
}
