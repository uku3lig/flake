{ config, _utils, ... }:
let
  secrets = _utils.setupSharedSecrets config { secrets = [ "frpToken" ]; };
in
{
  imports = [ secrets.generate ];

  services.frp = {
    enable = true;
    role = "server";
    settings = {
      bindPort = 7000;
      auth = {
        method = "token";
        token = "{{ .Envs.FRP_TOKEN }}";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ]; # forgejo-ssh
    allowedTCPPortRanges = [
      {
        from = 6000;
        to = 7000;
      }
    ];
  };

  systemd.services.frp.serviceConfig.EnvironmentFile = secrets.get "frpToken";
}
