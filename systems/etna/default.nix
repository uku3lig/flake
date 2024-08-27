{
  lib,
  pkgs,
  config,
  _utils,
  ...
}: let
  tunnelId = "57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5";

  secrets = _utils.setupSharedSecrets config {secrets = ["frpToken"];};
  cfTunnelSecret = _utils.setupSingleSecret config "tunnelCreds" {
    owner = "cloudflared";
    group = "cloudflared";
  };
in {
  imports = [
    (lib.mkAliasOptionModule ["cfTunnels"] ["services" "cloudflared" "tunnels" tunnelId "ingress"])

    secrets.generate
    cfTunnelSecret.generate

    ./minecraft.nix
    ./dendrite.nix
    ./nextcloud.nix
    ./reposilite.nix
    ./uku.nix
    ./vaultwarden.nix
    ./forgejo.nix
    ./shlink.nix
    ./metrics.nix
    ./navidrome.nix
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;
    loader.systemd-boot.enable = true;
  };

  networking.interfaces.eno1 = {
    wakeOnLan.enable = true;
  };

  services = {
    jmusicbot = {
      enable = true;
      stateDir = "/var/lib/jmusicbot";
    };

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
        credentialsFile = cfTunnelSecret.path;
        default = "http_status:404";
      };
    };
  };

  systemd.services = {
    "cloudflared-tunnel-${tunnelId}".serviceConfig.RestartSec = "10s";
    frp.serviceConfig.EnvironmentFile = secrets.get "frpToken";
  };
}
