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
}
