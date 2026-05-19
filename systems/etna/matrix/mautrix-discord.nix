{ pkgs, config, ... }:
let
  mautrix-discord-lea = pkgs.mautrix-discord.overrideAttrs {
    version = "0.7.6-unstable-2026-05-18";

    src = pkgs.fetchFromGitHub {
      owner = "LeaPhant";
      repo = "mautrix-discord";
      rev = "4d3f0a0b5800967c18b3a1d7149a7290c4b9d745";
      hash = "sha256-/EZ2PCK6KYnLjKrpuvzutav7nxnh4qnnbg3iR+sWjeI=";
    };
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

      database = {
        type = "postgres";
        uri = "postgres:///mautrix-discord?host=/var/run/postgresql";
      };

      bridge = {
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
