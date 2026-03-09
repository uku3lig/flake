{ config, ... }:
let
  inherit (config.virtualisation.oci-containers) backend;
in
{
  virtualisation.oci-containers.containers.satisfactory = {
    image = "wolveix/satisfactory-server:latest";
    ports = [
      "7777:7777/udp"
      "7777:7777/tcp"
      "8888:8888/tcp"
    ];
    volumes = [ "/var/lib/satisfactory-server:/config" ];
    environment = {
      MAXPLAYERS = "4";
      PGID = "1000";
      PUID = "1000";
      STEAMBETA = "false";
    };
  };

  systemd.services."${backend}-satisfactory".serviceConfig = {
    MemoryHigh = "12G";
    MemoryMax = "16G";
  };

  services.frp.instances.default.settings.proxies = [
    {
      name = "satisfactory-tcp-7777";
      type = "tcp";
      localIp = "127.0.0.1";
      localPort = 7777;
      remotePort = 7777;
    }
    {
      name = "satisfactory-udp-7777";
      type = "udp";
      localIp = "127.0.0.1";
      localPort = 7777;
      remotePort = 7777;
    }
    {
      name = "satisfactory-tcp-8888";
      type = "tcp";
      localIp = "127.0.0.1";
      localPort = 8888;
      remotePort = 8888;
    }
  ];
}
