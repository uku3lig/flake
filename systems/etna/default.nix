{
  lib,
  config,
  _utils,
  ...
}:
let
  tunnelId = "57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5";

  secrets = _utils.setupSharedSecrets config { secrets = [ "frpToken" ]; };
  cfTunnelSecret = _utils.setupSingleSecret config "tunnelCreds" {
    owner = "cloudflared";
    group = "cloudflared";
  };
in
{
  assertions = [
    {
      assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.6.31";
      message = "Linux kernel is too old! Please upgrade to ~6.6.31 or 6.9+";
    }
  ];

  imports = [
    (lib.mkAliasOptionModule [ "cfTunnels" ] [ "services" "cloudflared" "tunnels" tunnelId "ingress" ])

    secrets.generate
    cfTunnelSecret.generate

    # essential configs, do not remove
    ./postgresql.nix

    # services
    ./cobalt.nix
    ./dendrite.nix
    ./forgejo.nix
    ./immich.nix
    ./jellyfin.nix
    ./metrics.nix
    ./minecraft.nix
    ./nextcloud.nix
    ./reposilite.nix
    ./satisfactory.nix
    ./shlink.nix
    ./uku.nix
    ./ups.nix
    ./vaultwarden.nix
  ];

  boot.loader.systemd-boot.enable = true;

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

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };
}
