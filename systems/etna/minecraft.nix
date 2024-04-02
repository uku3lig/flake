{config, ...}: {
  services = {
    frp = {
      enable = true;
      role = "client";
      settings = {
        common = {
          server_addr = "49.13.148.129";
          server_port = 7000;
        };

        minecraft = {
          type = "tcp";
          local_ip = "127.0.0.1";
          local_port = 25565;
          remote_port = 6000;
        };

        ragnamod7 = {
          type = "tcp";
          local_ip = "127.0.0.1";
          local_port = 25566;
          remote_port = 6001;
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
        USE_AIKAR_FLAGS = "true";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "all-the-mods-8";
        CF_FILE_ID = "4962718";
      };
    };

    "ragnamod7" = {
      image = "itzg/minecraft-server";
      ports = ["25566:25565"];
      volumes = [
        "/data/ragnamod7:/data"
        "/data/downloads:/downloads"
      ];
      environmentFiles = [
        config.age.secrets.minecraftEnv.path
      ];
      environment = {
        EULA = "true";
        MEMORY = "12G";
        USE_AIKAR_FLAGS = "true";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "ragnamod-vii";
        CF_FILE_ID = "5171286";
      };
    };
  };
}
