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
