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

    # despite not having postgres here, we match with etna for safety
    postgresql.package = pkgs.postgresql_16;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
