{
  lib,
  config,
  pkgs, # required for fudgeMyShitIn
  ...
} @ args: let
  tunnelId = "57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5";

  secretsPath = ../../secrets/etna;
  mkSecrets = builtins.mapAttrs (name: value: value // {file = "${secretsPath}/${name}.age";});
  mkSecret = name: other: mkSecrets {${name} = other;};

  fudgeMyShitIn = builtins.map (file: import file (args // {inherit mkSecret;}));
in {
  imports =
    [
      (lib.mkAliasOptionModule ["cfTunnels"] ["services" "cloudflared" "tunnels" tunnelId "ingress"])
    ]
    ++ fudgeMyShitIn [
      ./minecraft.nix
      ./attic.nix
      ./dendrite.nix
      ./nextcloud.nix
    ];

  age.secrets = mkSecrets {
    apiRsEnv = {};
    ukubotRsEnv = {};

    tunnelCreds = {
      owner = "cloudflared";
      group = "cloudflared";
    };
  };

  boot.loader.systemd-boot.enable = true;

  services = {
    api-rs = {
      enable = true;
      environmentFile = config.age.secrets.apiRsEnv.path;
    };

    ukubot-rs = {
      enable = true;
      environmentFile = config.age.secrets.ukubotRsEnv.path;
    };

    reposilite.enable = true;

    tailscale.extraUpFlags = ["--advertise-exit-node"];

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bw.uku3lig.net";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
      };
    };

    cloudflared = {
      enable = true;
      tunnels.${tunnelId} = {
        credentialsFile = config.age.secrets.tunnelCreds.path;

        ingress = {
          "api.uku3lig.net" = "http://localhost:5000";
          "bw.uku3lig.net" = "http://localhost:8222";
          "maven.uku3lig.net" = "http://localhost:8080";
        };

        default = "http_status:404";
      };
    };
  };
}
