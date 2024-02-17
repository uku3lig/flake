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
    ngrokEnv.file = "${path}/ngrokEnv.age";
  };

  boot.loader.systemd-boot.enable = true;

  networking.firewall.allowedTCPPorts = [4040];

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
      tunnels."57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5" = {
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

  virtualisation.oci-containers.containers = {
    "ngrok" = {
      image = "ngrok/ngrok";
      ports = ["4040:4040"];
      cmd = ["tcp" "25565"];
      extraOptions = ["--net=host"];
      environmentFiles = [config.age.secrets.ngrokEnv.path];
    };

    "minecraft" = {
      image = "itzg/minecraft-server";
      ports = ["25565:25565"];
      volumes = ["/data/minecraft:/data"];
      environment = {
        EULA = "true";
        MEMORY = "16G";
        MODRINTH_MODPACK = "adrenaserver";
        MODRINTH_VERSION = "1.5.0+1.20.4.fabric";
        MODRINTH_LOADER = "fabric";
      };
    };
  };
}
