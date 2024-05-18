{
  config,
  mkSecret,
  ...
}: {
  age.secrets = mkSecret "dendriteKey" {mode = "444";};
  cfTunnels."m.uku.moe" = "http://localhost:80";

  systemd.services.dendrite = {
    after = ["postgresql.service"];
    serviceConfig.RestartSec = 10;
  };

  services = {
    dendrite = let
      database = {
        connection_string = "postgres:///dendrite?host=/run/postgresql";
        max_open_conns = 50;
        max_idle_conns = 5;
        conn_max_lifetime = -1;
      };
    in {
      enable = true;
      httpPort = 8008;
      settings = {
        global = {
          server_name = "m.uku.moe";
          private_key = config.age.secrets.dendriteKey.path;
          inherit database;
        };

        client_api = {
          registration_disabled = true;
        };

        app_service_api = {inherit database;};
        federation_api = {inherit database;};
        key_server = {inherit database;};
        media_api = {inherit database;};
        mscs = {inherit database;};
        relay_api = {inherit database;};
        room_server = {inherit database;};
        sync_api = {inherit database;};
        user_api = {
          account_database = database;
          device_database = database;
        };
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = ["dendrite"];
      ensureUsers = [
        {
          name = "dendrite";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx = {
      enable = true;

      virtualHosts."m.uku.moe".locations = let
        server = {"m.server" = "m.uku.moe:443";};
        client = {"m.homeserver"."base_url" = "https://m.uku.moe";};
      in {
        "=/.well-known/matrix/server" = {
          return = "200 '${builtins.toJSON server}'";
        };

        "=/.well-known/matrix/client" = {
          return = "200 '${builtins.toJSON client}'";
        };

        "/" = {
          proxyPass = "http://localhost:8008";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host      $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_read_timeout         600;
            client_max_body_size       100M;
          '';
        };
      };
    };
  };
}
