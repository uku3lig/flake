{
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
