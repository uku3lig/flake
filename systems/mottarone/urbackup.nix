{ lib, pkgs, ... }:
{
  # requires overlay, see exprs/overlay.nix
  environment.systemPackages = [ pkgs.urbackup-client ];

  systemd.services."urbackup-client" = {
    after = [
      "syslog.target"
      "network.target"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.urbackup-client "urbackupclientbackend"} --config /etc/default/urbackupclient --no-consoletime";
      # these paths are hardcoded in the binary, see overlay
      StateDirectory = "urbackup urbackup/data";
      WorkingDirectory = "/var/lib/urbackup";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      # "Sending files during file backups (file server)"
      35621
      # "Commands and image backups"
      35623
    ];
    allowedUDPPorts = [
      # "UDP broadcasts for discovery"
      35622
    ];
  };
}
