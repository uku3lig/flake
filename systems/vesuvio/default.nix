{ pkgs, ... }:
{
  imports = [
    ./certificates.nix
    ./frp.nix
    ./gatus.nix
    ./mail
    ./networking.nix
    ./nginx.nix
    ./nitter.nix
    ./pocket-id.nix
  ];

  environment.systemPackages = with pkgs; [
    dig
    traceroute
  ];

  services = {
    openssh = {
      ports = [ 4269 ];
      openFirewall = true;
    };

    # Needed by the Hetzner Cloud password reset feature.
    qemuGuest.enable = true;

    # Hetzner DNS does not work with DoT
    # resolved = {
    #   dnsovertls = "false";
    #   dnssec = "false";
    # };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864/2
  systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];

  zramSwap.enable = true;
}
