{
  lib,
  pkgs,
  config,
  _utils,
  ...
}: let
  inherit (config.virtualisation.oci-containers) backend;

  secret = _utils.setupSingleSecret config "minecraftEnv" {};

  atm9 = _utils.mkMinecraftServer config {
    name = "atm9";
    port = 25565;
    remotePort = 6004;
    tag = "java17";
    memory = "8G";
    envFiles = [secret.path];
    env = {
      USE_AIKAR_FLAGS = "true";
      MOD_PLATFORM = "AUTO_CURSEFORGE";
      CF_SLUG = "all-the-mods-9";
      CF_FILE_ID = "5458414";
    };
  };

  lynn = _utils.mkMinecraftServer config {
    name = "lynn";
    port = 25567;
    remotePort = 6002;
    memory = "4G";
    envFiles = [secret.path];
    env = {
      USE_AIKAR_FLAGS = "true";
      TYPE = "MODRINTH";
      MODRINTH_MODPACK = "https://modrinth.com/modpack/adrenaserver/version/1.6.0+1.20.6.fabric";
    };
  };
in {
  imports = [
    secret.generate

    atm9
    lynn
  ];

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
