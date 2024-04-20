{
  lib,
  config,
  mkSecret,
  ...
}: let
  mkMinecraftServer = name: {
    port,
    frpPort,
    memory ? "4G",
    env ? {},
  }: {
    virtualisation.oci-containers.containers.${name} = {
      image = "itzg/minecraft-server";
      ports = ["${builtins.toString port}:25565"];
      volumes = [
        "/data/${name}:/data"
        "/data/downloads:/downloads"
      ];
      environmentFiles = [config.age.secrets.minecraftEnv.path];
      environment =
        {
          EULA = "true";
          MEMORY = memory;
        }
        // env;
    };

    services.frp.settings.proxies = [
      {
        name = name;
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = port;
        remotePort = frpPort;
      }
    ];

    systemd.services."${config.virtualisation.oci-containers.backend}-${name}".serviceConfig.TimeoutSec = "300";
  };

  recursiveMerge = attrList:
    with lib; let
      f = attrPath:
        zipAttrsWith (
          n: values:
            if tail values == []
            then head values
            else if all isList values
            then unique (concatLists values)
            else if all isAttrs values
            then f (attrPath ++ [n]) values
            else last values
        );
    in
      f [] attrList;

  mkMinecraftServers = attrs: recursiveMerge (lib.mapAttrsToList mkMinecraftServer attrs);
in
  lib.recursiveUpdate {
    age.secrets = mkSecret "minecraftEnv" {};

    services.frp = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "49.13.148.129";
        serverPort = 7000;
      };
    };

    virtualisation.oci-containers.backend = "docker";
  }
  (mkMinecraftServers {
    ragnamod7 = {
      port = 25566;
      frpPort = 6001;
      memory = "10G";
      env = {
        USE_AIKAR_FLAGS = "true";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "ragnamod-vii";
        CF_FILE_ID = "5171286";
        CF_EXCLUDE_MODS = "314904";
        CF_IGNORE_MISSING_FILES = "mods/ftbbackups2-forge-1.18.2-1.0.23.jar";
      };
    };

    lynn = {
      port = 25567;
      frpPort = 6002;
      memory = "4G";
      env = {
        USE_AIKAR_FLAGS = "true";
        TYPE = "MODRINTH";
        MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaserver/version/1.5.0+1.20.4.fabric";
      };
    };
  })
