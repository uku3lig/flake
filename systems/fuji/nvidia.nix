{
  lib,
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = lib.mkForce ["nvidia"];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [pkgs.vaapiVdpau];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
  };

  # boot.extraModprobeConfig = ''
  #   options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  # '';

  hm.wayland.windowManager.hyprland.settings.env = [
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "WLR_NO_HARDWARE_CURSORS,1"
    "__EGL_VENDOR_LIBRARY_FILENAMES,/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json"
    "NVD_BACKEND,direct"
  ];
}
