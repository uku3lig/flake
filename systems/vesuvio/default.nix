{
  pkgs,
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSharedSecrets config {secrets = ["frpToken"];};
in {
  imports = [secrets.generate];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [dig traceroute];

  services = {
    resolved.enable = false;
    openssh.ports = [4269];

    frp = {
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
  };

  systemd.services.frp.serviceConfig.EnvironmentFile = secrets.get "frpToken";

  networking = {
    networkmanager.dns = "default";

    firewall = {
      allowedTCPPorts = [22]; # forgejo-ssh
      allowedTCPPortRanges = [
        {
          from = 6000;
          to = 7000;
        }
      ];
    };
  };
}
