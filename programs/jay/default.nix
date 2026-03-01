{ pkgs, camascaPkgs, ... }:
{
  imports = [
    ../fuzzel.nix
    ../sddm.nix
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
      xwayland-satellite

      camascaPkgs.wl-tray-bridge
    ];
  };

  xdg.portal.configPackages = [ pkgs.jay ];
  services.displayManager.sessionPackages = [ pkgs.jay ];

  hj = {
    ".config/jay/config.toml".source = ./config.toml;
    ".config/i3status/config".source = ./i3status-config;
  };
}
