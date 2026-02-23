{
  config,
  _utils,
  ...
}:
let
  grafanaKey = _utils.setupSingleSecret config "grafanaKey" {
    owner = "grafana";
    group = "grafana";
  };
in
{
  imports = [
    grafanaKey.generate
  ];
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 2432;
        root_url = "https://grafana.uku3lig.net";
      };
      security.secret_key = "$__file{${grafanaKey.path}}";
    };
  };
}
