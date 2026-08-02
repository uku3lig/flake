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

  techopolis = _utils.mkMinecraftServer config {
    name = "techopolis";
    port = 25565;
    remotePort = 6007;
    memory = "8G";
    env = {
      MODPACK_PLATFORM = "AUTO_CURSEFORGE";
      CF_SLUG = "techopolis-3";
      CF_FILE_ID = "8380837";
      MOTD = "\\u00A76Techopolis 3 \\u00A78(12.3)\\u00A7r\\n\\u00A75#oucoupstroisligue";
    };
  };
in
{
  imports = [
    secret.generate

    techopolis
  ];

  # TODO: control per-server
  systemd.services.restart-minecraft-servers = {
    wantedBy = [ "multi-user.target" ];
    startAt = "*-*-* 05:00:00";
    restartIfChanged = false;

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe' pkgs.systemd "systemctl"} restart ${backend}-mc-*.service";
    };
  };
}
