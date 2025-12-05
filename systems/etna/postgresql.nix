{ config, pkgs, ... }:
let
  location = "/data/backups/postgresql";
in
{
  services = {
    postgresql = {
      enable = true;
      # package is defined in configs/server.nix

      settings.port = 5432;
      enableTCPIP = true;

      ensureDatabases = [
        "gatus"
        "maddy"
        "pocketid"
        "roundcube"
      ];

      authentication = ''
        host maddy maddy vesuvio.fossa-macaroni.ts.net scram-sha-256
        host pocketid pocketid vesuvio.fossa-macaroni.ts.net scram-sha-256
        host roundcube roundcube vesuvio.fossa-macaroni.ts.net scram-sha-256

        local synapse synapse scram-sha-256
      '';
    };

    borgbackup.jobs.postgresql = config.passthru.makeBorg "postgresql" "/data/backups/postgresql";
  };

  systemd = {
    tmpfiles.rules = [ "d '${location}' 0700 postgres - - -" ];

    services.postgresql-backup = {
      description = "Backup of Postgresql databases";
      requires = [ "postgresql.target" ];
      startAt = "*-*-* 23:50:00";

      path = [
        pkgs.coreutils
        config.services.postgresql.package
      ];

      script = ''
        set -euo pipefail
        umask 0077 # ensure backup is only readable by postgres user

        IFS=$'\n' dbs=(`psql -tAc "SELECT datname FROM pg_database"`)

        for database in "''${dbs[@]}"; do
          if [[ ! "$database" =~ template* ]]; then
            echo "dumping $database"
            pg_dump -C "$database" > "${location}/$database.sql.tmp"
            mv "${location}/$database.sql.tmp" "${location}/$database.sql"
          fi
        done

        pg_dumpall --globals-only > "${location}/postgresql_global.sql"
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
      };
    };
  };
}
