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
    __GL_THREADED_OPTIMIZATIONS = "0";
  };

  hardware = {
    graphics.extraPackages = [ pkgs.libva-vdpau-driver ];
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

  programs.obs-studio.package = pkgs.obs-studio.override { cudaSupport = true; };
}
