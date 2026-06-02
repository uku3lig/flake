{
  lib,
  config,
  _utils,
  ...
}:
let
  envFile = _utils.setupSingleSecret config "pocketIdEnv" { };
  cfg = config.services.pocket-id;
in
{
  imports = [
    envFile.generate
  ];

  services = {
    pocket-id = {
      enable = true;
      environmentFile = envFile.path;

      settings = {
        APP_URL = "https://pocket.uku.moe";
        TRUST_PROXY = true;
        PORT = 1411;
      };
    };

    nginx.virtualHosts."pocket.uku.moe" = {
      locations."/".proxyPass = "http://localhost:${toString cfg.settings.PORT}";
    };
  };

  systemd.services."pocket-id".serviceConfig.RestartSec = lib.mkForce "10s";
}
