{config, ...}: {
  imports = [./common.nix];

  _module.args.nixinate = {
    host = config.networking.hostName;
    sshUser = "leo";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false; # hermetic fucks up for cross-system deployments
  };

  services = {
    tailscale.extraUpFlags = ["--advertise-exit-node"];

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
    };

    prometheus.exporters.node = {
      enable = true;
      port = 9091;
      enabledCollectors = ["systemd"];
    };
  };
}
