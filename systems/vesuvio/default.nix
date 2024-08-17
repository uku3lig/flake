{
  pkgs,
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSharedSecrets config {secrets = ["frpToken"];};
in {
  imports = [secrets.generate];

  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [dig traceroute];

  services = {
    openssh.ports = [4269];

    # Needed by the Hetzner Cloud password reset feature.
    qemuGuest.enable = true;

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

  systemd.services = {
    frp.serviceConfig.EnvironmentFile = secrets.get "frpToken";

    # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864/2
    qemu-guest-agent.path = [pkgs.shadow];
  };

  networking.firewall = {
    allowedTCPPorts = [22]; # forgejo-ssh
    allowedTCPPortRanges = [
      {
        from = 6000;
        to = 7000;
      }
    ];
  };
}
