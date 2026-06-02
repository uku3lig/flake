{ lib, config, ... }:
{
  options = {
    services.nginx.virtualHosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          config = {
            useACMEHost = lib.mkDefault config.networking.fqdn;
            forceSSL = lib.mkDefault true;
          };
        }
      );
    };
  };

  config.services.nginx = {
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedBrotliSettings = true;

    commonHttpConfig = ''
      access_log off;
    '';
  };
}
