{
  lib,
  pkgs,
  config,
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
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "550.142";
        sha256_64bit = "sha256-bdVJivBLQtlSU7Zre9oVCeAbAk0s10WYPU3Sn+sXkqE=";
        sha256_aarch64 = "sha256-sBp5fcCPMrfrTZTF1FqKo9g0wOWP+5+wOwQ7PLWI6wA=";
        openSha256 = "sha256-hjpwTR4I0MM5dEjQn7MKM3RY1a4Mt6a61Ii9KW2KbiY=";
        settingsSha256 = "sha256-Wk6IlVvs23cB4s0aMeZzSvbOQqB1RnxGMv3HkKBoIgY=";
        persistencedSha256 = "sha256-yQFrVk4i2dwReN0XoplkJ++iA1WFhnIkP7ns4ORmkFA=";
      };
      open = true;
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
