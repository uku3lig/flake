{
  config,
  pkgs,
  nixos-wsl,
  vscode-server,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.default
    vscode-server.nixosModules.default

    ../../programs/rust.nix
  ];

  services.vscode-server.enable = true;

  wsl = {
    enable = true;
    defaultUser = "leo";
    nativeSystemd = true;
    # useWindowsDriver = true;
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
}
