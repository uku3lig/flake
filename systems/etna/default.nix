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

  fudgeMyShitIn = builtins.map (file: import file (args // {inherit mkSecret mkSecrets;}));
in {
  imports =
    [
      (lib.mkAliasOptionModule ["cfTunnels"] ["services" "cloudflared" "tunnels" tunnelId "ingress"])
    ]
    ++ fudgeMyShitIn [
      ./minecraft.nix
      ./dendrite.nix
      ./nextcloud.nix
      ./reposilite.nix
      ./uku.nix
      ./vaultwarden.nix
      ./forgejo.nix
    ];

  age.secrets = mkSecrets {
    tunnelCreds = {
      owner = "cloudflared";
      group = "cloudflared";
    };

    frpToken = {};
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;

  services = {
    openssh.openFirewall = true;

    nginx.enable = true;

    frp = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "49.13.148.129";
        serverPort = 7000;
        auth = {
          method = "token";
          token = "{{ .Envs.FRP_TOKEN }}";
        };
      };
    };

    cloudflared = {
      enable = true;
      tunnels.${tunnelId} = {
        credentialsFile = config.age.secrets.tunnelCreds.path;
        default = "http_status:404";
      };
    };
  };

  systemd.services.frp.serviceConfig.EnvironmentFile = config.age.secrets.frpToken.path;
}
