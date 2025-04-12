{
  lib,
  config,
  pkgs,
  nixos-wsl,
  ...
}:
let
  mkExtraBin = lib.mapAttrsToList (
    name: value: {
      inherit name;
      src = lib.escapeShellArg value;
    }
  );
in
{
  imports = [
    nixos-wsl.nixosModules.default
  ];

  environment = {
    sessionVariables.LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
    systemPackages = [
      (pkgs.writeShellScriptBin "neovide" ''/bin/neovide-unwrapped --wsl "$@" &'')
      pkgs.parallel
    ];
  };

  wsl = {
    enable = true;
    defaultUser = "leo";
    useWindowsDriver = true;
    interop.includePath = false;

    extraBin = mkExtraBin {
      code = "/mnt/c/Users/Leo/AppData/Local/Programs/Microsoft VS Code/bin/code";
      neovide-unwrapped = "/mnt/c/Program Files/Neovide/neovide.exe";
      win32yank = "/mnt/c/Program Files/win32yank/win32yank.exe";
    };

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
}
