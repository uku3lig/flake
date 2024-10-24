{
  config,
  pkgs,
  nixos-wsl,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.default
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  environment.sessionVariables.LD_LIBRARY_PATH = ["/run/opengl-driver/lib"];

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
}
