{ config, _utils, ... }:
let
  envFile = _utils.setupSingleSecret config "pocketIdEnv" { };
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
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.pocket-id.settings.PORT}";
        recommendedProxySettings = true;
      };
    };
  };
}
