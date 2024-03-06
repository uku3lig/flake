{
  config,
  pkgs,
  ...
}: {
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

    matrix-conduit = {
      enable = true;
      settings.global = {
        server_name = "m.uku.moe";
        allow_registration = true;
        port = 6167;
      };
    };

    frp = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "45.10.154.114";
        serverPort = 7000;

        proxies = [
          {
            name = "minecraft";
            type = "tcp";
            localIp = "127.0.0.1";
            localPort = 25565;
            remotePort = 6000;
          }
        ];
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
          "m.uku.moe" = "http://localhost:80";
        };

        default = "http_status:404";
      };
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts."m.uku.moe" = {
        locations."=/.well-known/matrix/server" = let
          filename = "server-well-known";
          content = builtins.toJSON {"m.server" = "m.uku.moe:443";};
        in {
          alias = builtins.toString (pkgs.writeTextDir filename content) + "/";
          tryFiles = "${filename} =200";
          extraConfig = ''
            default_type application/json;
          '';
        };

        locations."/" = {
          proxyPass = "http://localhost:6167/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_buffering off;
            client_max_body_size 100M;
          '';
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    "minecraft" = {
      image = "itzg/minecraft-server";
      ports = ["25565:25565"];
      volumes = [
        "/data/minecraft:/data"
        "/data/downloads:/downloads"
      ];
      environmentFiles = [
        config.age.secrets.minecraftEnv.path
      ];
      environment = {
        EULA = "true";
        MEMORY = "12G";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "all-the-mods-8";
        CF_FILE_ID = "4962718";
      };
    };
  };
}
