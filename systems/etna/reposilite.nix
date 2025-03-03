{
  config,
  camasca,
  _utils,
  ...
}:
let
  dbPass = _utils.setupSingleSecret config "reposiliteDbPass" {
    owner = "reposilite";
    group = "reposilite";
  };
in
{
  imports = [
    camasca.nixosModules.reposilite
    dbPass.generate
  ];

  cfTunnels."maven.uku3lig.net" = "http://localhost:8080";

  services.reposilite = {
    enable = true;
    settings.port = 8080;
    database = {
      type = "postgresql";
      passwordFile = dbPass.path;
    };
  };
}
