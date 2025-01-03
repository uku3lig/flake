{ config, ... }:
{
  cfTunnels."im.uku.moe" = "http://localhost:${builtins.toString config.services.immich.port}";

  services.immich = {
    enable = true;

    settings = null;
    mediaLocation = "/data/immich";

    environment = {
      TZ = "Europe/Paris";
    };
  };
}
