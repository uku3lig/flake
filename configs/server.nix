{
  pkgs,
  config,
  _utils,
  ...
}:
let
  secrets = _utils.setupSharedSecrets config {
    secrets = [ "vmAuthToken" ];
  };
in
{
  imports = [
    ./common.nix
    secrets.generate
  ];

  _module.args.nixinate = {
    host = config.networking.hostName;
    sshUser = "leo";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false; # hermetic fucks up for cross-system deployments
  };

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
  ];

  services = {
    tailscale.extraUpFlags = [ "--advertise-exit-node" ];

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        UseDns = false;

        # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "sntrup761x25519-sha512@openssh.com"
        ];
      };
    };

    prometheus.exporters.node = {
      enable = true;
      port = 9091;
      enabledCollectors = [ "systemd" ];
    };

    vmagent = {
      enable = true;
      remoteWrite.url = "https://metrics.uku3lig.net/api/v1/write";
      extraArgs = [ "-remoteWrite.bearerTokenFile=\${CREDENTIALS_DIRECTORY}/vm_auth_token" ];
      prometheusConfig = {
        global.scrape_interval = "15s";

        scrape_configs = [
          {
            job_name = "node";
            static_configs = [
              { targets = [ "localhost:${builtins.toString config.services.prometheus.exporters.node.port}" ]; }
            ];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = config.networking.hostName;
              }
            ];
          }
        ];
      };
    };
  };

  systemd = {
    services = {
      vmagent.serviceConfig.LoadCredential = [ "vm_auth_token:${secrets.get "vmAuthToken"}" ];
      tailscaled.restartIfChanged = false;
    };

    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    watchdog = {
      # systemd will send a signal to the hardware watchdog at half the interval defined here, so every 10s.
      # If the hardware watchdog does not get a signal for 20s, it will forcefully reboot the system.
      runtimeTime = "20s";
      # Forcefully reboot if the final stage of the reboot hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = "30s";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}
