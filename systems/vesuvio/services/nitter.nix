{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  lockFile = pkgs.fetchurl {
    url = "https://github.com/uku3lig/nixpkgs/raw/935a49e91c0ee8f8a48fb68f7618986f5bc232d9/pkgs/by-name/ni/nitter/lock.json";
    hash = "sha256-IVHT+AtE5qulPXh6QExwS1n7G+VlyJSRrphSC3i0vFA=";
  };

  nitter = pkgs.nitter.overrideNimAttrs (p: {
    version = "0-unstable-2026-06-16";

    src = p.src.overrideAttrs {
      rev = "35882ed88d422b1355b66a1ff8c1144bffdc7bdf";
      hash = "sha256-U3FDhTZIcTDNKbSjrb0F9+Y5Q6GHLmGnmwXoZ5XfATc=";
    };

    inherit lockFile;
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
