{
  pkgs,
  config,
  _utils,
  ...
}:
let
  accounts = _utils.setupSingleSecret config "nitterAccounts" { };

  nitterUpdated = pkgs.nitter.overrideAttrs {
    version = "0-unstable-2025-02-26";
    src = pkgs.fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "41fa47bfbf3917e9b3ac4f7b49c89a75a7a2bd44";
      hash = "sha256-cmYlmzCJl1405TuYExGw3AOmjdY0r7ObmmLCAom+Fyw=";
    };
  };
in
{
  imports = [ accounts.generate ];

  services.nitter = {
    enable = true;
    package = nitterUpdated;
    guestAccounts = accounts.path;
    server = {
      hostname = "nit.uku.moe";
      port = 8081;
    };
  };

  systemd.services.nitter.environment = {
    NITTER_SESSIONS_FILE = "%d/guestAccountsFile";
  };

  services.nginx.virtualHosts."nit.uku.moe" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://localhost:8081";
  };
}
