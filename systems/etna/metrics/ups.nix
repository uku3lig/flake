{
  _utils,
  config,
  ...
}:
let
  upsdPass = _utils.setupSingleSecret config "upsdUserPass" { };
in
{
  imports = [ upsdPass.generate ];

  power.ups = {
    enable = true;
    mode = "standalone";

    upsd.listen = [
      {
        address = "127.0.0.1";
        port = 3493;
      }
    ];

    users.admin = {
      passwordFile = upsdPass.path;
      instcmds = [ "ALL" ];
      actions = [
        "SET"
        "FSD"
      ];
    };

    ups.eaton-3s-850 = {
      driver = "usbhid-ups";
      port = "auto";
      description = "Eaton 3S 850 UPS";
    };

    upsmon.monitor.eaton-3s-850 = {
      user = "admin";
      passwordFile = upsdPass.path;
    };
  };

  services = {
    prometheus.exporters.nut = {
      enable = true;
      user = "root";
      nutUser = "admin";
      passwordPath = upsdPass.path;
      nutVariables = [
        "battery.charge"
        "battery.runtime"
        "battery.voltage"
        "device.info"
        "input.voltage"
        "ups.load"
        "ups.status"
      ];
    };

    vmagent.prometheusConfig.scrape_configs = [
      {
        job_name = "nut";
        metrics_path = "/ups_metrics";
        params.ups = [ "eaton-3s-850" ];
        static_configs = [
          {
            targets = [ "localhost:${builtins.toString config.services.prometheus.exporters.nut.port}" ];
            labels.ups = "eaton-3s-850";
          }
        ];
      }
    ];
  };
}
