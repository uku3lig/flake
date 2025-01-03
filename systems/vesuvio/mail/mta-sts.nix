{ _utils, ... }:
{
  services.nginx.virtualHosts."mta-sts.uku3lig.net" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "mta-sts.uku.moe" ];

    locations."/.well-known/" = _utils.mkNginxFile {
      filename = "mta-sts.txt";
      content = ''
        version: STSv1
        mode: enforce
        mx: mx1.uku3lig.net
        max_age: 604800
      '';
    };
  };
}
