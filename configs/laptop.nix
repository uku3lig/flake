{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [./desktop.nix];

  hardware.bluetooth.enable = true;

  services = {
    libinput.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs.light.enable = true;

  # hyprland stuff
  services.blueman = lib.mkIf config.programs.hyprland.enable {enable = true;};
  hm.wayland.windowManager.hyprland.settings.exec-once = with pkgs; [
    "${lib.getExe networkmanagerapplet}"
    "${lib.getExe' blueman "blueman-applet"}"
  ];
}
