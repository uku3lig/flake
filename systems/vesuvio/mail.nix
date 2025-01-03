{ config, ... }:
let
  certName = "mail.c.uku3lig.net";
  certLocation = config.security.acme.certs.${certName}.directory;
in
{
  security.acme.certs.${certName} = {
    group = config.services.maddy.group;
    extraLegoRenewFlags = [ "--reuse-key" ]; # soopyc said its more secure
  };

  services.maddy = {
    enable = true;
    hostname = "mx1.uku3lig.net";
    primaryDomain = "uku3lig.net";
    localDomains = [
      "$(primary_domain)"
      "uku.moe"
    ];

    tls = {
      loader = "file";
      certificates = [
        {
          certPath = "${certLocation}/fullchain.pem";
          keyPath = "${certLocation}/key.pem";
        }
      ];
    };

    config = ''

    '';
  };
}
