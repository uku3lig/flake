{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../programs/rust.nix
  ];

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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;

    extraPackages = with pkgs; [
      mesa.drivers
    ];
  };
}
