{ pkgs, ... }:
{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;

      port = 5432;
      enableTCPIP = true;
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      location = "/data/backups/postgresql";
    };
  };
}
