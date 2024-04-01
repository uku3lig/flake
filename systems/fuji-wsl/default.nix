{
  config,
  pkgs,
  attic,
  ...
}: {
  environment.systemPackages = [
    attic.packages.${pkgs.system}.attic
  ];

  wsl = {
    enable = true;
    defaultUser = "leo";
    nativeSystemd = true;
    wslConf.network = {
      hostname = config.networking.hostName;
      generateResolvConf = false;
    };
  };
}
