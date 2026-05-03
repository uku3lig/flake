{ pkgs, camascaPkgs, ... }:
{
  imports = [
    ../fuzzel.nix
    ../plm.nix
  ];

  environment = {
    variables.XCURSOR_THEME = "Bibata-Modern-Ice";

    systemPackages = with pkgs; [
      grim
      i3status
      jay
      mako
      slurp
      swaybg
      wl-tray-bridge
      xwayland-satellite

      camascaPkgs.hulk-gamma
    ];
  };

  xdg.portal.configPackages = [ pkgs.jay ];
  services.displayManager.sessionPackages = [ pkgs.jay ];

  hj = {
    ".config/jay/config.toml".source = ./config.toml;
    ".config/i3status/config".source = ./i3status-config;
  };
}
