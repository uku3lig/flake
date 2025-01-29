{ camasca, ... }:
{
  imports = [ camasca.nixosModules.shlink ];

  cfTunnels."uku.moe" = "http://localhost:8081";

  services = {
    shlink = {
      enable = true;
      environment = {
        PORT = "8081";
        DEFAULT_DOMAIN = "uku.moe";
        IS_HTTPS_ENABLED = "true";
        DB_DRIVER = "postgres";
        DB_UNIX_SOCKET = "/var/run/postgresql";
      };
    };

    postgresql = {
      ensureDatabases = [ "shlink" ];
      ensureUsers = [
        {
          name = "shlink";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
