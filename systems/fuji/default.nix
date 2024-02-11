{
  lib,
  pkgs,
  ...
}: {
  imports = [./nvidia.nix];

  services.xserver.videoDrivers = ["amdgpu"];

  hm = {
    home.packages = with pkgs; [ryujinx];

    wayland.windowManager.hyprland.settings.monitor = lib.mkForce ["DP-1,3840x2160@144,0x0,1.5" "HDMI-A-1,1440x900@60,1920x300,1"];
  };
}
