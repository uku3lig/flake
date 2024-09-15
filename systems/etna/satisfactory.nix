{config, ...}: let
  inherit (config.virtualisation.oci-containers) backend;
in {
  virtualisation.oci-containers.containers.satisfactory = {
    image = "wolveix/satisfactory-server:v1.8.5";
    ports = ["7777:7777/udp" "7777:7777/tcp"];
    volumes = ["/var/lib/satisfactory-server:/config"];
    environment = {
      MAXPLAYERS = "4";
      PGID = "1000";
      PUID = "1000";
      ROOTLESS = "false";
      STEAMBETA = "false";
    };
  };

  systemd.services."${backend}-satisfactory".serviceConfig = {
    MemoryHigh = "12G";
    MemoryMax = "16G";
  };

  networking.firewall = {
    allowedTCPPorts = [7777];
    allowedUDPPorts = [7777];
  };
}
