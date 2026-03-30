{
  config,
  _utils,
  api-rs,
  ukubot-ts,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    secrets = [
      "apiRsEnv"
      "ukubotTsEnv"
    ];
  };
in
{
  imports = [
    api-rs.nixosModules.default
    ukubot-ts.nixosModules.default

    secrets.generate
  ];

  services = {
    api-rs = {
      enable = true;
      environmentFile = secrets.get "apiRsEnv";
    };

    ukubot-ts = {
      enable = true;
      environmentFile = secrets.get "ukubotTsEnv";
      createDatabase = true;
    };
  };
}
