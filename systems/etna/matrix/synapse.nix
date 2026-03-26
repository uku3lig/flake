{ config, _utils, ... }:
let
  secrets = _utils.setupSecrets config {
    secrets = [
      "synapseSigningKey"
      "synapseExtraConfig"
      "masSharedSecret"
    ];
    extra.owner = "matrix-synapse";
  };
in
{
  imports = [ secrets.generate ];

  # not enough to get shit running but whatever
  # it's at least good enough as a manual "note" for future me
  services.postgresql.ensureDatabases = [ "synapse" ];

  services.matrix-synapse = {
    enable = true;
    extras = [
      "oidc" # OpenID Connect authentication
      "postgres" # PostgreSQL database backend
      "systemd" # Provide the JournalHandler used in the default log_config
      "url-preview" # Support for oEmbed URL previews
    ];

    # note that this doesn't properly merge config files,
    # which is why all the db config is in the secret file
    extraConfigFiles = [ (secrets.get "synapseExtraConfig") ];

    settings = {
      server_name = "rei.uku.moe";
      public_baseurl = "https://rei.uku.moe";
      allow_public_rooms_over_federation = true;
      federation_client_minimum_tls_version = 1.2;
      url_preview_enabled = true;
      enable_registration = false;
      max_upload_size = "100M";
      suppress_key_server_warning = true;
      max_event_delay_duration = "24h";

      signing_key_path = secrets.get "synapseSigningKey";

      matrix_authentication_service = {
        enabled = true;
        endpoint = "http://localhost:8010/";
        secret_path = secrets.get "masSharedSecret";
      };

      experimental_features = {
        # required for element-call
        msc3266_enabled = true; # room summary api
        msc4222_enabled = true; # syncv2 state_after (whatever that means)
      };

      # relax rate limits, required for element-call
      rc_message = {
        per_second = 0.5;
        burst_count = 30;
      };
      rc_delayed_event_mgmt = {
        per_second = 1;
        burst_count = 20;
      };

      listeners = [
        {
          bind_addresses = [ "0.0.0.0" ];
          port = 8009;
          x_forwarded = true;
          tls = false;
          resources = [
            {
              names = [
                "client" # implies ["media" "static"]
                "federation"
                "keys"
                "openid"
                "replication"
              ];
            }
          ];
        }
      ];

      trusted_key_servers = [
        {
          server_name = "matrix.org";
          verify_keys = {
            "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          };
        }
      ];

      # old_signing_keys = {
      #   "ed25519:ShsA0qVs" = {
      #     key = "69NNU6gjAz4C3++7iX6fA1iiL/JXkOu1HtTqFeoKshU";
      #     expired_ts = 1713201107547;
      #   };
      #   "ed25519:a_bDJQ" = {
      #     key = "dWYWgSsaatJQgEV+Q4tuRDl4UYmN7F75Gp3NPaZN5kY";
      #     expired_ts = 1712706212704;
      #   };
      #   "ed25519:a_QYIk" = {
      #     key = "7W8BJr3pPH1XOhwB9YmvpShnDhnEj8svaEVePrTt4gE";
      #     expired_ts = 1712705368930;
      #   };
      # };
    };
  };
}
