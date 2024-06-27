{
  lib,
  pkgs,
  config,
  mkSecret,
  ...
}: let
  inherit (config.virtualisation.oci-containers) backend;

  mkMinecraftServer = name: {
    port,
    remotePort,
    tag ? "java21",
    dataDir ? "/var/lib/${name}",
    memory ? "4G",
    env ? {},
    extraPorts ? [],
  }: {
    virtualisation.oci-containers.containers.${name} = {
      image = "itzg/minecraft-server:${tag}";
      ports = ["${builtins.toString port}:25565"] ++ extraPorts;
      volumes = ["${dataDir}:/data"];
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
        inherit name remotePort;
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = port;
      }
    ];

    systemd.services."${backend}-${name}".serviceConfig.TimeoutSec = "300";
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

    virtualisation.oci-containers.backend = "docker";

    systemd.services.restart-minecraft-servers = {
      wantedBy = ["multi-user.target"];
      script = ''
        ${lib.getExe' pkgs.systemd "systemctl"} restart ${backend}-*.service
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.restart-minecraft-servers = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 05:00:00";
        Persistent = true;
        Unit = "restart-minecraft-servers.service";
      };
    };
  }
  (mkMinecraftServers {
    atm9 = {
      port = 25565;
      remotePort = 6004;
      tag = "java17";
      memory = "8G";
      env = {
        USE_AIKAR_FLAGS = "true";
        MOD_PLATFORM = "AUTO_CURSEFORGE";
        CF_SLUG = "all-the-mods-9";
        CF_FILE_ID = "5458414";
      };
    };

    lynn = {
      port = 25567;
      remotePort = 6002;
      memory = "4G";
      env = {
        USE_AIKAR_FLAGS = "true";
        TYPE = "MODRINTH";
        MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaserver/version/1.6.0+1.20.4.fabric";
      };
    };
  })
