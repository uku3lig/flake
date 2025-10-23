{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
let
  tunnelId = "57f51ad7-25a0-45f3-b113-0b6ae0b2c3e5";

  frpToken = _utils.setupSharedSecrets config { secrets = [ "frpToken" ]; };
  secrets = _utils.setupSecrets config {
    secrets = [
      "tunnelCreds"
      "borgSshKey"
      "borgPassphrase"
    ];
  };
in
{
  assertions = [
    {
      assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.6.31";
      message = "Linux kernel is too old! Please upgrade to ~6.6.31 or 6.9+";
    }
    {
      assertion = lib.versions.majorMinor pkgs.borgbackup.version == "1.4";
      message = "Borg is not version 1.4! Got: ${pkgs.borgbackup.version}";
    }
  ];

  passthru = {
    makeBorg = name: paths: {
      inherit paths;
      repo = "ssh://u488412@u488412.your-storagebox.de:23/./${name}";
      encryption = {
        mode = "repokey";
        passCommand = "cat ${secrets.get "borgPassphrase"}";
      };
      compression = "zstd,7";
      extraArgs = [ "--remote-path=borg-1.4" ];
      extraCreateArgs = [ "--stats" ];
      extraPruneArgs = [ "--stats" ];
      extraCompactArgs = [ "--verbose" ];
      startAt = "daily";
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 2;
      };
      environment = {
        BORG_RSH = "ssh -i ${secrets.get "borgSshKey"}";
      };
    };
  };

  imports = [
    (lib.mkAliasOptionModule [ "cfTunnels" ] [ "services" "cloudflared" "tunnels" tunnelId "ingress" ])

    frpToken.generate
    secrets.generate

    # essential configs, do not remove
    ./postgresql.nix

    # services
    ./cobalt.nix
    # ./dendrite.nix
    ./forgejo.nix
    ./immich.nix
    ./jellyfin.nix
    ./metrics.nix
    ./minecraft.nix
    ./nextcloud.nix
    ./reposilite.nix
    # ./satisfactory.nix
    ./share.nix
    ./shlink.nix
    ./slskd.nix
    ./synapse.nix
    ./uku.nix
    ./ups.nix
    ./vaultwarden.nix
    ./zipline.nix
  ];

  boot.loader.systemd-boot.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
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
        credentialsFile = secrets.get "tunnelCreds";
        default = "http_status:404";
      };
    };
  };

  systemd.services = {
    "cloudflared-tunnel-${tunnelId}".serviceConfig.RestartSec = "10s";
    frp.serviceConfig.EnvironmentFile = frpToken.get "frpToken";
  };

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };
}
