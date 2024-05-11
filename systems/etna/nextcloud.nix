{
  config,
  pkgs,
  mkSecret,
  ...
}: {
  age.secrets = mkSecret "nextcloudAdminPass" {
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.name;
  };

  cfTunnels."cloud.uku3lig.net" = "http://localhost:80";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;

    https = true;
    hostName = "cloud.uku3lig.net";
    datadir = "/data/nextcloud";

    configureRedis = true;

    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPass.path;
    };
  };
}
