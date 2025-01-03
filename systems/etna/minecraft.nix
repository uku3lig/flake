{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
let
  inherit (config.virtualisation.oci-containers) backend;

  secret = _utils.setupSingleSecret config "minecraftEnv" { };

  lynn = _utils.mkMinecraftServer config {
    name = "lynn";
    port = 25567;
    remotePort = 6002;
    memory = "4G";
    envFiles = [ secret.path ];
    env = {
      USE_AIKAR_FLAGS = "true";
      TYPE = "MODRINTH";
      MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaline/version/1.24.0+1.20.6.fabric";
    };
  };

  vanilla = _utils.mkMinecraftServer config {
    name = "vanilla";
    port = 25565;
    remotePort = 6005;
    memory = "4G";
    envFiles = [ secret.path ];
    env = {
      USE_AIKAR_FLAGS = "true";
      TYPE = "MODRINTH";
      MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaline/version/1.24.0+1.21.1.fabric";
    };
  };

  ukuserv = _utils.mkMinecraftServer config {
    name = "ukuserv";
    port = 25566;
    remotePort = 6006;
    memory = "4G";
    envFiles = [ secret.path ];
    env = {
      USE_AIKAR_FLAGS = "true";
      TYPE = "MODRINTH";
      MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaline/version/1.24.0+1.21.1.fabric";
      MODRINTH_PROJECTS = "spark, no-chat-reports";
    };
  };
in
{
  imports = [
    secret.generate

    lynn
    vanilla
    ukuserv
  ];

  systemd.services.restart-minecraft-servers = {
    wantedBy = [ "multi-user.target" ];
    startAt = "*-*-* 05:00:00";
    restartIfChanged = false;

    script = "${lib.getExe' pkgs.systemd "systemctl"} restart ${backend}-mc-*.service";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
