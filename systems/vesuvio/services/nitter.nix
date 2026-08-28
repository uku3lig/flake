{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  nitter = pkgs.nitter.overrideNimAttrs (p: {
    version = "0-unstable-2026-08-26";

    src = p.src.overrideAttrs {
      rev = "e4aefbc210a75d90d919fedba92f830c965ed989";
      hash = "sha256-N1epzIKIcXqZMMBiq5eeACRF34hZMIP0q3R8S+kAjS8=";
    };
  });
in
{
  imports = [ accounts.generate ];

  services.nitter = {
    enable = true;
    package = nitter;
    sessionsFile = accounts.path;
    server = {
      hostname = "nit.uku.moe";
      port = 8081;
    };
  };

  services.nginx.virtualHosts."nit.uku.moe" = {
    locations."/" = {
      proxyPass = "http://unix:${config.services.anubis.instances.nitter.settings.BIND}";
      recommendedProxySettings = true;
    };
  };

  services.anubis.instances."nitter".settings = {
    TARGET = "http://localhost:${toString config.services.nitter.server.port}";
    BIND = "/run/anubis/anubis-nitter/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-nitter/anubis-metrics.sock";
  };
}
