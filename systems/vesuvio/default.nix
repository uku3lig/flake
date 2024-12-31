{ pkgs, ... }:
{
  imports = [
    ./frp.nix
    ./hetzner.nix
  ];

  environment.systemPackages = with pkgs; [
    dig
    traceroute
  ];

  services.openssh = {
    ports = [ 4269 ];
    openFirewall = true;
  };
}
