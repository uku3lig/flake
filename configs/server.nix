{
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSharedSecrets config {
    secrets = ["vmAuthToken"];
  };
in {
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

  services = {
    tailscale.extraUpFlags = ["--advertise-exit-node"];

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
    };

    prometheus.exporters.node = {
      enable = true;
      port = 9091;
      enabledCollectors = ["systemd"];
    };

    vmagent = {
      enable = true;
      remoteWrite.url = "https://metrics.uku3lig.net/api/v1/write";
      extraArgs = ["-remoteWrite.bearerToken $VM_AUTH_TOKEN"];
      prometheusConfig = {
        global.scrape_interval = "15s";

        scrape_configs = [
          {
            job_name = "node";
            static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.node.port}"];}];
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

  systemd.services.vmagent.serviceConfig.EnvironmentFile = secrets.get "vmAuthToken";
}
