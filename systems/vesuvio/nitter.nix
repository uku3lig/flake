{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  nitter = pkgs.nitter.overrideAttrs {
    version = "0-unstable-2025-12-08";

    src = pkgs.fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "baeaf685d32098cd90ae1424cf8a19f3de9b0e2c";
      hash = "sha256-y8cLFmqjNXRQramQ4SFgjJeoVOEBEuYctJ5/3vpySVY=";
    };
  };
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
