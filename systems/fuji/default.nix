{pkgs, ...}: {
  imports = [./nvidia.nix];

  services.xserver.videoDrivers = ["amdgpu"];

  hm = {
    home.packages = with pkgs; [ryujinx];

    wayland.windowManager.hyprland.settings = {
      monitor = "DP-1,3840x2160@144,0x0,1.5";

      xwayland.force_zero_scaling = true;

      env = [
        "GDK_SCALE,1.5"
        "XCURSOR_SIZE,24"
      ];
    };
  };
}
