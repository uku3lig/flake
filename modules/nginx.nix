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
        lib.types.submodule (sub: {
          options = {
            iocaineLocation = lib.mkOption {
              description = "Location to redirect iocaine to on this vhost. Does nothing if null.";
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
          };

          config = lib.mkMerge [
            (lib.mkIf cfg.isProxy {
              useACMEHost = lib.mkDefault config.networking.fqdn;
              forceSSL = lib.mkDefault true;
              quic = lib.mkDefault true;
              extraConfig = ''
                add_header Alt-Svc 'h3=":443"; ma=3600, h2=":443"; ma=3600';
              '';
            })
            (lib.mkIf (sub.config.iocaineLocation != null) {
              locations."/" = {
                proxyPass = "http://iocaine";
                extraConfig = ''
                  # allow nginx to intercept non-200 responses
                  proxy_intercept_errors on;

                  # optionally retry upstream on certain failures
                  proxy_next_upstream error timeout;

                  # treat 421 as a special fallback condition
                  # treat 502 when iocaine is down
                  error_page 421 502 = ${sub.config.iocaineLocation};

                  # don't spend time compressing garbage
                  brotli off;
                  gzip off;
                '';
              };
            })
          ];
        })
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
