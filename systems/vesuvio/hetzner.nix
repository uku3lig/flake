{ pkgs, ... }:
{
  services = {
    # Needed by the Hetzner Cloud password reset feature.
    qemuGuest.enable = true;

    # Hetzner DNS does not work with DoT
    resolved = {
      dnssec = "allow-downgrade";
      dnsovertls = "false";
    };
  };

  # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864/2
  systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];

  zramSwap.enable = true;
}
