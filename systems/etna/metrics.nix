{config, ...}: let
  vmcfg = config.services.victoriametrics;
  pmcfg = config.services.prometheus;
in {
  cfTunnels."grafana.uku3lig.net" = "http://localhost:2432";

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 2432;
        root_url = "https://grafana.uku3lig.net";
      };
    };
  };

  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:9090";
    retentionPeriod = 5 * 12; # 5 years !!!!
  };

  services.vmagent = {
    enable = true;
    remoteWrite.url = "http://${vmcfg.listenAddress}/api/v1/write";
    prometheusConfig = {
      global.scrape_interval = "15s";

      scrape_configs = [
        {
          job_name = "node";
          static_configs = [{targets = ["localhost:${builtins.toString pmcfg.exporters.node.port}"];}];
        }

        {
          job_name = "victoriametrics";
          static_configs = [{targets = ["${builtins.toString vmcfg.listenAddress}"];}];
        }

        {
          job_name = "api-rs";
          static_configs = [{targets = ["localhost:5001"];}];
        }
      ];
    };
  };
}
