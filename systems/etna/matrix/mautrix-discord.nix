{ pkgs, config, ... }:
let
  mautrix-discord-lea = pkgs.mautrix-discord.overrideAttrs {
    version = "0.7.6-unstable-2026-06-23";

    src = pkgs.fetchFromGitHub {
      owner = "LeaPhant";
      repo = "mautrix-discord";
      rev = "3ad936795da1487a3a9f870bbb323870220ae926";
      hash = "sha256-Fqnv7SCeWLufKrz5r4t/gV2WBpv0QeBiltVWLOLis88=";
    };

    vendorHash = "sha256-5bjhjvNBnftKqeASrAYjsQNfuz5xQlP6ibcCue6Z2/4=";
  };
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  services.mautrix-discord = {
    enable = true;
    package = mautrix-discord-lea;

    registerToSynapse = true;

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
        direct_media = {
          enabled = true;
          server_name = "discord-media.rei.uku.moe";
        };
        disable_reply_mention = true;
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
