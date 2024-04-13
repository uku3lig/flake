{
  config,
  mkSecret,
  ...
}: {
  age.secrets = mkSecret "minecraftEnv" {};

  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "49.13.148.129";
      serverPort = 7000;

      proxies = [
        {
          name = "minecraft";
          type = "tcp";
          localIp = "127.0.0.1";
          localPort = 25565;
          remotePort = 6000;
        }
        {
          name = "ragnamod7";
          type = "tcp";
          localIp = "127.0.0.1";
          localPort = 25566;
          remotePort = 6001;
        }
      ];
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
        MEMORY = "10G";
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
        MEMORY = "10G";
        USE_AIKAR_FLAGS = "true";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "ragnamod-vii";
        CF_FILE_ID = "5171286";
      };
    };
  };
}
