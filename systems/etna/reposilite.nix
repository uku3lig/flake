{ camasca, ... }:
{
  imports = [ camasca.nixosModules.reposilite ];

  cfTunnels."maven.uku3lig.net" = "http://localhost:8080";

  services.reposilite = {
    enable = true;
    database.type = "sqlite";
    settings.port = 8080;
  };
}
