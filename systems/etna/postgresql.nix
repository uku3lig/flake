{ config, pkgs, ... }:
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

        local synapse synapse scram-sha-256
      '';
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      location = "/data/backups/postgresql";
      # default is -C, which is not an option in dumpall
      # TODO: should probably backup databases individually
      pgdumpOptions = "";
    };

    borgbackup.jobs.postgresql = config.passthru.makeBorg "postgresql" "/data/backups/postgresql";
  };
}
