{
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
    locations."/".proxyPass = "http://localhost:8081";
  };
}
