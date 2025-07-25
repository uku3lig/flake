{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
{
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  boot.kernelParams = [
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  hardware = {
    graphics.extraPackages = [ pkgs.vaapiVdpau ];
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  hj.".config/hypr/hyprland.conf".text = _utils.toHyprconf {
    env = [
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "NVD_BACKEND,direct"
    ];
  };
}
