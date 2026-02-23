{ pkgs, ... }:
{
  imports = [
    ./mail
    ./services
    ./web
    ./hetzner.nix
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
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
