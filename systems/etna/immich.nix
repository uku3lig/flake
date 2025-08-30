{ config, ... }:
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";

    settings = null;
    mediaLocation = "/data/immich";

    environment = {
      TZ = "Europe/Paris";
    };
  };

  services.borgbackup.jobs.immich = config.passthru.makeBorg "immich" "/data/immich" // {
    exclude = [
      "*/thumbs/"
      "*/encoded-video/"
    ];
  };
}
