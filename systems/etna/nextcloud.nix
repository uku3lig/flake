{
  pkgs,
  config,
  _utils,
  ...
}: let
  adminPass = _utils.setupSingleSecret config "nextcloudAdminPass" {
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.name;
  };
in {
  imports = [adminPass.generate];

  # nextcloud generates nginx config
  cfTunnels."cloud.uku3lig.net" = "http://localhost:80";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;

    https = true;
    hostName = "cloud.uku3lig.net";
    datadir = "/data/nextcloud";

    configureRedis = true;

    config = {
      adminpassFile = adminPass.path;
    };
  };
}
