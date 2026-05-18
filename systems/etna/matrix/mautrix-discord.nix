{ pkgs, config, ... }:
let
  mautrix-discord-lea = pkgs.mautrix-discord.overrideAttrs {
    version = "0.7.6-unstable-2026-05-18";

    src = pkgs.fetchFromGitHub {
      owner = "LeaPhant";
      repo = "mautrix-discord";
      rev = "108240e7c3fa0e9ba671f534dd184f72f6d7d446";
      hash = "sha256-LYvEGZm3UX56qoh074i6kMo1ZFW9QsJX7KLRIbEXiwk=";
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
