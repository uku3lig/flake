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

  nomifactory = _utils.mkMinecraftServer config {
    name = "nomi";
    port = 25565;
    remotePort = 6007;
    tag = "java8";
    memory = "8G";
    envFiles = [ secret.path ];
    env = {
      TYPE = "AUTO_CURSEFORGE";
      CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/nomi-ceu/files/5821400";
    };
  };
in
{
  imports = [
    secret.generate

    lynn
    nomifactory
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
