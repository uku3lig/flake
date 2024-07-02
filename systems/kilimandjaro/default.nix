{
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    initrd.kernelModules = ["i915"];
    kernelParams = ["i915.force_probe=9a49"];
  };

  hardware = {
    bluetooth.enable = true;

    graphics.extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl intel-media-driver];
  };

  services = {
    # xserver.videoDrivers = ["intel"];
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
