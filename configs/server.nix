{config, ...}: {
  _module.args.nixinate = {
    host = config.networking.hostName;
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = true;
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
  };
}
