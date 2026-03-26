{
  config,
  camasca,
  _utils,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    secrets = [
      "masClientSecret"
      "masExtraConfig"
      "masSharedSecret"
    ];
    # group to avoid conflict with synapse, which also needs the shared secret
    extra = {
      group = "matrix-authentication-service";
      mode = "440";
    };
  };
in
{
  imports = [
    camasca.nixosModules.matrix-authentication-service

    secrets.generate
  ];

  services.matrix-authentication-service = {
    enable = true;
    createDatabase = true;
    extraConfigFiles = [ (secrets.get "masExtraConfig") ];

    settings = {
      http = {
        public_base = "https://auth.rei.uku.moe";

        listeners = [
          {
            name = "web";
            resources = [
              { name = "discovery"; }
              { name = "human"; }
              { name = "oauth"; }
              { name = "compat"; }
              { name = "graphql"; }
              { name = "assets"; }
            ];
            binds = [
              {
                host = "0.0.0.0";
                port = 8010;
              }
            ];
            proxy_protocol = false;
          }
        ];

        trusted_proxies = [
          "127.0.0.1/8"
          "::1/128"
          "100.0.0.0/8"
        ];
      };

      matrix = {
        homeserver = config.services.matrix-synapse.settings.server_name;
        kind = "synapse";
        endpoint = "http://localhost:8009";
        secret_file = secrets.get "masSharedSecret";
      };

      upstream_oauth2.providers = [
        {
          id = "01KMMS3H6HAZYWCHP07VH5X7BJ";
          synapse_idp_id = "oidc-pocket_id";
          human_name = "Pocket ID";
          issuer = "https://pocket.uku.moe";
          client_id = "8dfc700d-7583-4c67-bf22-cc5bd1979699";
          client_secret_file = secrets.get "masClientSecret";
          token_endpoint_auth_method = "client_secret_basic";
          scope = "openid profile";
          claims_imports = {
            localpart = {
              action = "require";
              template = "{{ user.preferred_username }}";
            };
            displayname = {
              action = "suggest";
              template = "{{ user.name }}";
            };
          };
        }
      ];

      passwords = {
        enabled = true;
        schemes = [
          # version 1 is in the secret, because it contains the pepper from synapse
          {
            version = 2;
            algorithm = "argon2id";
          }
        ];
        minimum_complexity = 3;
      };

      email.transport = "blackhole";
    };
  };
}
