{ pkgs, config, ... }:
let
  mautrix-discord-lea = pkgs.mautrix-discord.overrideAttrs {
    version = "0.7.6-unstable-2026-05-18";

    src = pkgs.fetchFromGitHub {
      owner = "LeaPhant";
      repo = "mautrix-discord";
      rev = "d94ba03ef40defc76c24a23a83ededc8ee1b9d08";
      hash = "sha256-59FOzCeOWzO46j/zKqMCac+j0WvzEpNr3cg47D+gqQQ=";
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
