{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@uku.moe";
      webroot = "/var/lib/acme/acme-challenge";
    };

    certs."vps.uku3lig.net".extraDomainNames = [
      "api.uku3lig.net"
      "bw.uku3lig.net"
      "cobalt.uku3lig.net"
      "git.uku3lig.net"
      "grafana.uku3lig.net"
      "jellyfin.uku3lig.net"
      "maven.uku3lig.net"
      "memos.uku3lig.net"
      "metrics.uku3lig.net"
      "paper.uku3lig.net"
      "status.uku3lig.net"
      "zipline.uku3lig.net"

      "uku.moe"
      "auth.rei.uku.moe"
      "im.uku.moe"
      "nit.uku.moe"
      "pocket.uku.moe"
      "rei.uku.moe"
      "slsk.uku.moe"
      "v.uku.moe"

      # mail
      "mail.uku3lig.net"
      "mta-sts.uku3lig.net"
      "mta-sts.uku.moe"
    ];
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
