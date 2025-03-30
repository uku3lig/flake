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

  environment = {
    sessionVariables.LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
    systemPackages = [
      (pkgs.writeShellScriptBin "neovide" ''/bin/neovide-unwrapped --wsl "$@" &'')
    ];
  };

  wsl = {
    enable = true;
    defaultUser = "leo";
    useWindowsDriver = true;
    interop.includePath = false;

    extraBin = [
      {
        name = "code";
        src = lib.escapeShellArg "/mnt/c/Users/Leo/AppData/Local/Programs/Microsoft VS Code/bin/code";
      }
      {
        name = "neovide-unwrapped";
        src = lib.escapeShellArg "/mnt/c/Program Files/Neovide/neovide.exe";
      }
    ];

    wslConf.network = {
      hostname = config.networking.hostName;
      generateResolvConf = false;
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings = {
        mysqld.bind_address = "127.0.0.1";
      };
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
      enableTCPIP = true;
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
