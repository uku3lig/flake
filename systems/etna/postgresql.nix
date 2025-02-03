{ pkgs, ... }:
{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;

      settings.port = 5432;
      enableTCPIP = true;

      ensureDatabases = [
        "gatus"
        "maddy"
        "roundcube"
      ];

      authentication = ''
        host gatus gatus vesuvio.fossa-macaroni.ts.net scram-sha-256
        host maddy maddy vesuvio.fossa-macaroni.ts.net scram-sha-256
        host roundcube roundcube vesuvio.fossa-macaroni.ts.net scram-sha-256
      '';
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      location = "/data/backups/postgresql";
    };
  };
}
