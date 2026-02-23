{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };
in
{
  imports = [ accounts.generate ];

  services.nitter = {
    enable = true;
    sessionsFile = accounts.path;
    server = {
      hostname = "nit.uku.moe";
      port = 8081;
    };
  };

  services.nginx.virtualHosts."nit.uku.moe" = {
    forceSSL = true;
    enableACME = true;
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
