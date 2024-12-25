{ ... }:
{
  services.immich = {
    enable = true;

    settings = null;
    mediaLocation = "/data/immich";

    environment = {
      TZ = "Europe/Paris";
    };

    host = "0.0.0.0";
    openFirewall = true;
  };
}
