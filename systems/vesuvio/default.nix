{ pkgs, ... }:
{
  imports = [
    ./certificates.nix
    ./frp.nix
    ./gatus.nix
    ./hetzner.nix
    ./mail
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
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
