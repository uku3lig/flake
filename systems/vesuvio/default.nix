{ pkgs, ... }:
{
  imports = [
    ./certificates.nix
    ./frp.nix
    ./hetzner.nix
    ./nginx.nix
  ];

  environment.systemPackages = with pkgs; [
    dig
    traceroute
  ];

  services = {
    nginx.enable = true;
    openssh = {
      ports = [ 4269 ];
      openFirewall = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
