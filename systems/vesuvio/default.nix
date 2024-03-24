{config, ...}: {
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh.openFirewall = true;

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
}
