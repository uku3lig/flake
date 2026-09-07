{ lib, config, ... }:
let
  cfg = config.system.julie.nginx;
in
{
  options = {
    system.julie.nginx = {
      isProxy = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    services.nginx.virtualHosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          config = lib.mkIf cfg.isProxy {
            useACMEHost = lib.mkDefault config.networking.fqdn;
            forceSSL = lib.mkDefault true;
            quic = lib.mkDefault true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":443"; ma=3600, h2=":443"; ma=3600';
            '';
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
