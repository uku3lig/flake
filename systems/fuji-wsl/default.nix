{config, ...}: {
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
