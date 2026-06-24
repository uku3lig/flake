{
  pkgs,
  config,
  _utils,
  ...
}:
let
  mautrix-discord-lea = pkgs.mautrix-discord.overrideAttrs {
    version = "0.7.6-unstable-2026-06-24";

    src = pkgs.fetchFromGitHub {
      owner = "LeaPhant";
      repo = "mautrix-discord";
      rev = "36dba1447d31cd339dee981a26198730e8e4adb9";
      hash = "sha256-VVoFItRZr+zHTYB/VrqRH1SqK00rCuYJF3kRq9OVWMA=";
    };

    vendorHash = "sha256-5bjhjvNBnftKqeASrAYjsQNfuz5xQlP6ibcCue6Z2/4=";
  };

  envFile = _utils.setupSingleSecret config "mautrixDiscordEnv" { };
in
{
  imports = [ envFile.generate ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  services.mautrix-discord = {
    enable = true;
    package = mautrix-discord-lea;

    registerToSynapse = true;
    environmentFile = envFile.path;

    settings = {
      homeserver = {
        address = "http://localhost:8009";
        domain = config.services.matrix-synapse.settings.server_name;
      };

      appservice = {
        address = "http://localhost:29334";
        hostname = "0.0.0.0";
        port = 29334;
      };

      database = {
        type = "postgres";
        uri = "postgres:///mautrix-discord?host=/var/run/postgresql";
      };

      bridge = {
        public_address = "https://discord-media.rei.uku.moe";
        disable_reply_mention = true;

        direct_media = {
          enabled = true;
          server_name = "discord-media.rei.uku.moe";
        };

        emoji_application = {
          enabled = true;
          app_id = "$DISCORD_APP_ID";
          app_token = "$DISCORD_APP_TOKEN";
        };

        permissions = {
          "*" = "relay";
          "@uku:rei.uku.moe" = "admin";
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = [ "mautrix-discord" ];
    ensureUsers = [
      {
        name = "mautrix-discord";
        ensureDBOwnership = true;
      }
    ];
  };
}
