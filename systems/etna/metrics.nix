{
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

  services.prometheus = {
    enable = true;
    port = 9090;

    globalConfig.scrape_interval = "15s";

    exporters = {
      node = {
        enable = true;
        port = 9091;
        enabledCollectors = ["systemd"];
      };
    };

    scrapeConfigs = [
      {
        job_name = "scrape-node";
        static_configs = [
          {
            targets = ["localhost:9091"];
          }
        ];
      }
      {
        job_name = "scrape-api-rs";
        static_configs = [
          {
            targets = ["localhost:5001"];
          }
        ];
      }
    ];
  };
}
