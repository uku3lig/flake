{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@uku.moe";
      webroot = "/var/lib/acme/acme-challenge";
    };
  };

  services.nginx.virtualHosts = {
    "acme.uku3lig.net" = {
      serverAliases = [
        "*.uku3lig.net"
        "*.uku.moe"
      ];

      locations."/.well-known/acme-challenge".root = config.security.acme.defaults.webroot;
    };
  };

  # /var/lib/acme/acme-challenge must be writable by the ACME user and readable by the Nginx user.
  # The easiest way to achieve this is to add the Nginx user to the ACME group.
  users.users.nginx.extraGroups = [ "acme" ];
}
