{lib, ...}: {
  # imports = [./nvidia.nix];

  services.xserver.videoDrivers = ["amdgpu"];

  hm.wayland.windowManager.hyprland.settings.monitor = lib.mkForce ["DP-1,1920x1200@60,0x0,1" "HDMI-A-1,1440x900@60,1920x300,1"];
}
