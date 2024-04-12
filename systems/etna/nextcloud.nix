{config, pkgs, ...}: {
  cfTunnels."cloud.uku3lig.net" = "http://localhost:80";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;

    https = true;
    hostName = "cloud.uku3lig.net";
    datadir = "/data/nextcloud";

    configureRedis = true;

    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPass.path;
    };
  };
}