{
  config,
  mkSecrets,
  ...
}: {
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
