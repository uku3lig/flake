{
  config,
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
  imports = [ dbPass.generate ];

  services.reposilite = {
    enable = true;
    settings.port = 8080;
    database = {
      type = "postgresql";
      passwordFile = dbPass.path;
    };
  };
}
