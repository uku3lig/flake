{
  config,
  _utils,
  api-rs,
  ukubot-rs,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    secrets = [
      "apiRsEnv"
      "ukubotRsEnv"
    ];
  };
in
{
  imports = [
    api-rs.nixosModules.default
    ukubot-rs.nixosModules.default

    secrets.generate
  ];

  cfTunnels."api.uku3lig.net" = "http://localhost:5000";

  services = {
    api-rs = {
      enable = true;
      environmentFile = secrets.get "apiRsEnv";
    };

    ukubot-rs = {
      enable = true;
      environmentFile = secrets.get "ukubotRsEnv";
    };
  };
}
