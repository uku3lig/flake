{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  nitter = pkgs.nitter.overrideAttrs (p: {
    version = "0-unstable-2026-03-30";

    src = p.src.overrideAttrs {
      rev = "7d431781c37748faef5ed15bfa6b4865d875b99f";
      hash = "sha256-LkGxQ7kvVNKXkYtDmpnwU3gbSO9caEcyUk8rnC2f81Y=";
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
    forceSSL = true;
    useACMEHost = "vps.uku3lig.net";
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
