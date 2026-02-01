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
in
{
  imports = [
    secret.generate
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
