{
  config,
  _utils,
  ...
}:
let
  secretKey = _utils.setupSingleSecret config "dendriteKey" { };
in
{
  imports = [ secretKey.generate ];

  systemd.services.dendrite = {
    after = [ "postgresql.service" ];
    serviceConfig.RestartSec = 10;
  };

  services = {
    dendrite =
      let
        database = {
          connection_string = "postgres:///dendrite?host=/run/postgresql";
          max_open_conns = 50;
          max_idle_conns = 5;
          conn_max_lifetime = -1;
        };
      in
      {
        enable = true;
        httpPort = 8008;
        loadCredential = [ "private_key:${secretKey.path}" ];

        settings = {
          version = 2;

          global = {
            inherit database;
            server_name = "m.uku.moe";
            private_key = "$CREDENTIALS_DIRECTORY/private_key";

            old_private_keys = [
              {
                public_key = "69NNU6gjAz4C3++7iX6fA1iiL/JXkOu1HtTqFeoKshU";
                key_id = "ed25519:ShsA0qVs";
                expired_at = 1713201107547;
              }
              {
                public_key = "dWYWgSsaatJQgEV+Q4tuRDl4UYmN7F75Gp3NPaZN5kY";
                key_id = "ed25519:a_bDJQ";
                expired_at = 1712706212704;
              }
              {
                public_key = "7W8BJr3pPH1XOhwB9YmvpShnDhnEj8svaEVePrTt4gE";
                key_id = "ed25519:a_QYIk";
                expired_at = 1712705368930;
              }
            ];
          };

          client_api = {
            registration_disabled = true;
          };

          logging = [
            {
              type = "std";
              level = "info";
            }
          ];

          app_service_api = { inherit database; };
          federation_api = { inherit database; };
          key_server = { inherit database; };
          media_api = { inherit database; };
          mscs = { inherit database; };
          relay_api = { inherit database; };
          room_server = { inherit database; };
          sync_api = { inherit database; };
          user_api = {
            account_database = database;
            device_database = database;
          };
        };
      };

    postgresql = {
      ensureDatabases = [ "dendrite" ];
      ensureUsers = [
        {
          name = "dendrite";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
