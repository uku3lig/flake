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

  gtnhBoner = _utils.mkMinecraftServer config {
    name = "gtnh-boner";
    port = 25566;
    remotePort = 6008;
    tag = "java25";
    memory = "8G";
    envFiles = [ secret.path ];
    env = {
      TYPE = "GTNH";
      GTNH_PACK_VERSION = "2.8.4";
      MOTD = "GregTech New Horizons 2.8.4 \\u00A78(Big Boner™ Edition)";
    };
  };
in
{
  imports = [
    secret.generate

    gtnhBoner
  ];

  # TODO: control per-server
  systemd.services.restart-minecraft-servers = {
    wantedBy = [ "multi-user.target" ];
    startAt = "*-*-* 12:00:00";
    restartIfChanged = false;

    script = "${lib.getExe' pkgs.systemd "systemctl"} restart ${backend}-mc-*.service";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
