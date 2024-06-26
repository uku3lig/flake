{
  config,
  mkSecrets,
  api-rs,
  ukubot-rs,
  ...
}: {
  imports = [
    api-rs.nixosModules.default
    ukubot-rs.nixosModules.default
  ];

  age.secrets = mkSecrets {
    apiRsEnv = {};
    ukubotRsEnv = {};
  };

  cfTunnels."api.uku3lig.net" = "http://localhost:5000";

  services = {
    api-rs = {
      enable = true;
      environmentFile = config.age.secrets.apiRsEnv.path;
    };

    ukubot-rs = {
      enable = true;
      environmentFile = config.age.secrets.ukubotRsEnv.path;
    };
  };
}
