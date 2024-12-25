{ pkgs, ... }:
{
  # utility packages for hyprland, since you know it's not a DE

  hm.home.packages = with pkgs; [
    gnome.gnome-calculator
    mate.eom
    nwg-look
    pavucontrol
  ];

  programs = {
    seahorse.enable = true;
    file-roller.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
      ];
    };
  };
}
