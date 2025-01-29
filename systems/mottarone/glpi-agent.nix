{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.glpi-agent ];

  systemd.services."glpi-agent" = {
    description = "GLPI agent";
    after = [
      "syslog.target"
      "network.target"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.glpi-agent} --conf-file /etc/glpi-agent/agent.cfg --vardir /var/lib/glpi-agent --daemon --no-fork";
      ExecReload = "kill -HUP $MAINPID";
      CapabilityBoundingSet = "~CAP_SYS_PTRACE";

      StateDirectory = "glpi-agent";
      WorkingDirectory = "/var/lib/glpi-agent";
    };
  };
}
