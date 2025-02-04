{
  lib,
  config,
  pkgs,
  nixos-wsl,
  ...
}:
{
  imports = [
    nixos-wsl.nixosModules.default
  ];

  environment.sessionVariables.LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];

  wsl = {
    enable = true;
    defaultUser = "leo";
    nativeSystemd = true;
    useWindowsDriver = true;
    wslConf.network = {
      hostname = config.networking.hostName;
      generateResolvConf = false;
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa.drivers
    ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld.bind_address = "127.0.0.1";
    };
  };

  system.replaceDependencies = {
    cutoffPackages = lib.mkForce [ ]; # wsl does not have a ramdisk
    replacements = [
      {
        oldDependency = pkgs.ffmpeg-full;
        newDependency = pkgs.ffmpeg-full.override { withUnfree = true; };
      }
    ];
  };
}
