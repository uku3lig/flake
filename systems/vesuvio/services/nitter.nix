{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  nitter = pkgs.nitter.overrideAttrs (p: {
    version = "0-unstable-2026-04-16";

    src = p.src.overrideAttrs {
      rev = "74f5ff8accc0faace7c0955a4be03b3ad159609b";
      hash = "sha256-qSrQICQND+9LqNvuFx6VjCdcl3FZZWbhjuxjgfPB3Ss=";
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
