{
  lib,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = lib.mkForce ["nvidia"];

  boot.kernelParams = [
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  hardware = {
    opengl.extraPackages = [pkgs.vaapiVdpau];
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  hm.wayland.windowManager.hyprland.settings.env = [
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "NVD_BACKEND,direct"
  ];
}
