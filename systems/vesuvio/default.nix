{config, ...}: {
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh.ports = [4269];

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

  age.secrets.frpToken.file = ../../secrets/etna/frpToken.age;
  systemd.services.frp.serviceConfig.EnvironmentFile = config.age.secrets.frpToken.path;

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
