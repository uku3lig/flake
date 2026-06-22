{ config, camascaPkgs, ... }: {
  services = {
    jellyfin = {
      enable = true;
      dataDir = "/data/jellyfin";
    };

    postgresql = {
      ensureDatabases = [ "jellyfin" ];
      ensureUsers = [
        {
          name = "jellyfin";
          ensureDBOwnership = true;
        }
      ];
    };
  };

  systemd = {
    services.jellyfin = {
      path = [ config.services.postgresql.package ];
      environment = {
        POSTGRES_HOST = "/var/run/postgresql";
        POSTGRES_PASSWORD = "";
      };
    };

    tmpfiles.rules = [
      "C+ ${camascaPkgs.jellyfin-pgsql}/lib/jellyfin-pgsql - - - - ${config.services.jellyfin.dataDir}/plugins/PostgreSQL"
      "Z ${config.services.jellyfin.dataDir}/plugins/PostgreSQL - jellyfin jellyfin"
    ];
  };
}
