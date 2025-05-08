{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.fuzzel ];

  hj.".config/fuzzel/fuzzel.ini".text = lib.generators.toINI { } {
    main = {
      font = "Iosevka Nerd Font:size=16";
      dpi-aware = false;
      horizontal-pad = 20;
    };

    border.radius = 8;

    colors = {
      background = "24273aff"; # base
      border = "91d7e3cc"; # sky
      text = "cad3f5ff"; # text
      match = "a6da95ff"; # green
      selection = "f4dbd6ff"; # rosewater
      selection-text = "181926ff"; # crust
      selection-match = "40a02bff"; # latte green
    };
  };
}
