{
  config,
  pkgs,
  nixos-wsl,
  ...
}:
let
  windowsBin =
    path:
    let
      name = builtins.elemAt (builtins.splitVersion (baseNameOf path)) 0;
    in
    (pkgs.writeShellScriptBin name ''
      "${path}" "$@"
    '');
in
{
  imports = [
    nixos-wsl.nixosModules.default
  ];

  environment = {
    sessionVariables.LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
    systemPackages = with pkgs; [
      (writeShellScriptBin "neovide" ''"/mnt/c/Program Files/Neovide/neovide.exe" --wsl "$@" &'')
      (windowsBin "/mnt/c/Users/Leo/AppData/Local/Programs/Microsoft VS Code/bin/code")
      # both needed for neovim clipboard support
      (windowsBin "/mnt/c/Windows/System32/clip.exe")
      (windowsBin "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
    ];
  };

  wsl = {
    enable = true;
    defaultUser = "leo";
    useWindowsDriver = true;
    interop.includePath = false;

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
