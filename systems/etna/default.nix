{config, ...}: {
  age.secrets = let
    path = ../../secrets/etna;
  in {
    tunnelCreds = {
      file = "${path}/tunnelCreds.age";
      owner = "cloudflared";
      group = "cloudflared";
    };

    apiRsEnv.file = "${path}/apiRsEnv.age";
    ukubotRsEnv.file = "${path}/ukubotRsEnv.age";
  };

  boot.loader.systemd-boot.enable = true;

  services = {
    api-rs = {
      enable = true;
      environmentFile = config.age.secrets.apiRsEnv.path;
    };

    ukubot-rs = {
      enable = true;
      environmentFile = config.age.secrets.ukubotRsEnv.path;
    };

    cloudflared = {
      enable = true;
      tunnels."57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5" = {
        credentialsFile = config.age.secrets.tunnelCreds.path;

        ingress = {
          "api.uku3lig.net" = "http://localhost:5000";
        };

        default = "http_status:404";
      };
    };
  };
}
