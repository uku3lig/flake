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

  hm.programs.fish.interactiveShellInit = lib.mkAfter ''
    if test -f ~/.ssh/id_ed25519
      ssh-add -l | grep -q (ssh-keygen -lf ~/.ssh/id_ed25519) || ssh-add ~/.ssh/id_ed25519
    end
  '';

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
