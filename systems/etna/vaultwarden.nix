{
  config,
  _utils,
  ...
}:
let
  envFile = _utils.setupSingleSecret config "vaultwardenEnv" { };
in
{
  imports = [ envFile.generate ];

  services = {
    vaultwarden = {
      enable = true;
      environmentFile = envFile.path;
      # backupDir = "/data/backups/vaultwarden";
      dbBackend = "postgresql";
      config = {
        DOMAIN = "https://bw.uku3lig.net";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::";
        ROCKET_PORT = 8222;

        DATABASE_URL = "postgresql:///vaultwarden";

        SMTP_HOST = "mx1.uku3lig.net";
        SMTP_FROM = "services@uku3lig.net";
        SMTP_PORT = 465;
        SMTP_SECURITY = "force_tls";
      };
    };

    postgresql = {
      ensureDatabases = [ "vaultwarden" ];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
    };

    borgbackup.jobs.vaultwarden = config.passthru.makeBorg "vaultwarden" "/var/lib/vaultwarden";
  };
}
