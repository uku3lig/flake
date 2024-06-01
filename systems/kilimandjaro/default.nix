{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.kernelModules = ["i915"];
    kernelParams = ["i915.force_probe=9a49"];
  };

  hardware = {
    bluetooth.enable = true;

    opengl = let
      packages = with pkgs; [vaapiIntel libvdpau-va-gl intel-media-driver];
    in {
      extraPackages = packages;
      extraPackages32 = packages;
    };
  };


  services = {
    # xserver.videoDrivers = ["intel"];
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    blueman.enable = true;
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
