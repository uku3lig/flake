{
  lib,
  pkgs,
  ...
}: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services = {
    xserver.videoDrivers = ["intel"];
    libinput.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs.light.enable = true;

  hm = {
    home.packages = with pkgs; [
      networkmanagerapplet
      protonvpn-gui
    ];

    wayland.windowManager.hyprland.settings.exec-once = with pkgs; [
      "${lib.getExe networkmanagerapplet}"
      "${lib.getExe' blueman "blueman-applet"}"
    ];
  };
}
