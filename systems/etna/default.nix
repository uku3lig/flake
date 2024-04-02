{
  lib,
  config,
  ...
}: let
  tunnelId = "57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5";
in {
  imports = [
    (lib.mkAliasOptionModule ["cfTunnels"] ["services" "cloudflared" "tunnels" tunnelId "ingress"])

    ./minecraft.nix
    ./attic.nix
  ];

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
    ngrokEnv.file = "${path}/ngrokEnv.age";
    minecraftEnv.file = "${path}/minecraftEnv.age";
    atticEnv.file = "${path}/atticEnv.age";
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

    reposilite.enable = true;

    tailscale.extraUpFlags = ["--advertise-exit-node"];

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bw.uku3lig.net";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
      };
    };

    cloudflared = {
      enable = true;
      tunnels.${tunnelId} = {
        credentialsFile = config.age.secrets.tunnelCreds.path;

        ingress = {
          "api.uku3lig.net" = "http://localhost:5000";
          "bw.uku3lig.net" = "http://localhost:8222";
          "maven.uku3lig.net" = "http://localhost:8080";
        };

        default = "http_status:404";
      };
    };
  };
}
