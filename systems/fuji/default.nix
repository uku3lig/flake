{ pkgs, _utils, ... }:
{
  imports = [
    ./nvidia.nix
    ../../programs/niri
    ../../programs/games.nix
  ];

  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
  ];

  hardware.bluetooth.enable = true;

  hj.".config/hypr/hyprland.conf".text = _utils.toHyprconf {
    monitor = "DP-1,3840x2160@144,0x0,1.5";
    xwayland.force_zero_scaling = true;
    env = [
      "GDK_SCALE,1.5"
      "XCURSOR_SIZE,24"
    ];
  };
}
