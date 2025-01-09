{
  cfTunnels."jellyfin.uku3lig.net" = "http://localhost:8096";

  services.jellyfin = {
    enable = true;
    dataDir = "/data/jellyfin";
  };
}
