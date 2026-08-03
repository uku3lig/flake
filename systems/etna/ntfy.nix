{ config, _utils, ... }:
let
  envFile = _utils.setupSingleSecret config "ntfyEnv" { };
in
{
  imports = [ envFile.generate ];

  services.ntfy-sh = {
    enable = true;
    environmentFile = envFile.path;

    settings = {
      listen-http = ":8088";
      base-url = "https://ntfy.uku3lig.net";
      behind-proxy = true;

      database-url = "postgres:///ntfy-sh?host=/var/run/postgresql";

      auth-default-access = "deny-all";
      auth-access = [
        "*:up*:write-only" # up stands for UnifiedPush
      ];
      enable-login = true;
      require-login = true;

      # set by default by the module so we need to override them
      auth-file = "";
      cache-file = "";
      web-push-file = "";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "ntfy-sh" ];
    ensureUsers = [
      {
        name = "ntfy-sh";
        ensureDBOwnership = true;
      }
    ];
  };
}
