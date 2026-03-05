{
  lib,
  config,
  _utils,
  ...
}:
let
  envFile = _utils.setupSingleSecret config "ziplineEnv" { };
in
{
  imports = [ envFile.generate ];

  services.zipline = {
    enable = true;
    database.createLocally = true;
    environmentFiles = [ envFile.path ];

    settings = {
      CORE_HOSTNAME = "0.0.0.0";
      CORE_PORT = 3001;
      DATASOURCE_TYPE = "local";
      DATASOURCE_LOCAL_DIRECTORY = "/data/zipline";

      FEATURES_OAUTH_REGISTRATION = "true";
    };
  };

  systemd.services.zipline.serviceConfig = {
    ReadWritePaths = [ "/data/zipline" ];
    ProtectProc = lib.mkForce "default";
  };
}
