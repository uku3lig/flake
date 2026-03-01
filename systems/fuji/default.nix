{
  pkgs,
  _utils,
  ritornello,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    ./nvidia.nix
    ../../programs/niri
    ../../programs/jay
    ../../programs/games.nix
  ];

  environment.systemPackages = with pkgs; [
    wineWow64Packages.waylandFull
    ritornello.packages.${system}.ritornello
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

  programs = {
    niri = {
      cursorTheme = "Bibata-Modern-Ice";
      cursorSize = 32;
    };

    waywall = {
      width = 3840;
      height = 2160;
    };
  };
}
