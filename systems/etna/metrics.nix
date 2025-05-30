{
  config,
  mystia,
  _utils,
  ...
}:
let
  vmcfg = config.services.victoriametrics;
  secrets = _utils.setupSharedSecrets config { secrets = [ "vmAuthToken" ]; };
  vmauthEnv = _utils.setupSingleSecret config "vmauthEnv" { };
in
{
  imports = [
    mystia.nixosModules.vmauth
    secrets.generate
    vmauthEnv.generate
  ];

  cfTunnels = {
    "grafana.uku3lig.net" = "http://localhost:2432";
    "metrics.uku3lig.net" = {
      service = "http://localhost:9089";
      path = "/api/.*/write";
    };
  };

  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 2432;
          root_url = "https://grafana.uku3lig.net";
        };
      };
    };

    victoriametrics = {
      enable = true;
      listenAddress = "127.0.0.1:9090";
      retentionPeriod = "5y";
    };

    vmagent = {
      enable = true;
      prometheusConfig = {
        global.scrape_interval = "15s";

        # node scraping is sent to vm directly via vmauth
        scrape_configs = [
          {
            job_name = "victoriametrics";
            static_configs = [ { targets = [ "${builtins.toString vmcfg.listenAddress}" ]; } ];
          }

          {
            job_name = "api-rs";
            static_configs = [ { targets = [ "localhost:5001" ]; } ];
          }
        ];
      };
    };

    vmauth = {
      enable = true;
      listenAddress = "127.0.0.1:9089";
      environmentFile = vmauthEnv.path;
      authConfig.users = [
        {
          bearer_token = "%{VM_AUTH_TOKEN}";
          url_prefix = "http://${vmcfg.listenAddress}";
        }
      ];
    };
  };
}
