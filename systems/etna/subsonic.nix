{
  cfTunnels."subsonic.uku3lig.net" = "http://localhost:4040";

  services.subsonic = {
    enable = true;
    port = 4040;
    maxMemory = 200;

    defaultMusicFolder = "/data/subsonic/music";
    defaultPlaylistFolder = "/data/subsonic/playlist";
    defaultPodcastFolder = "/data/subsonic/podcast";
  };
}