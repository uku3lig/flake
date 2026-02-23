{
  pkgs,
  config,
  _utils,
  ...
}:
let
  adminPass = _utils.setupSingleSecret config "nextcloudAdminPass" {
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.name;
  };
in
{
  imports = [ adminPass.generate ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;

    https = true;
    hostName = "cloud.uku3lig.net";
    datadir = "/data/nextcloud";

    database.createLocally = true;
    configureRedis = true;

    config = {
      adminpassFile = adminPass.path;
      dbtype = "pgsql";
    };
  };
}
