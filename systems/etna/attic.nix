{config, ...}: {
  cfTunnels."attic.uku3lig.net" = "http://localhost:6000";

  services.atticd = {
    enable = true;
    credentialsFile = config.age.secrets.atticEnv.path;

    settings = {
      listen = "[::]:6000";
      api-endpoint = "https://attic.uku3lig.net/";

      storage = {
        type = "local";
        path = "/data/attic";
      };

      chunking = {
        nar-size-threshold = 65536; # 64 KiB
        min-size = 16384; # 16 KiB
        avg-size = 65536; # 64 KiB
        max-size = 262144; # 256 KiB
      };

      compression.type = "zstd";

      garbage-collection = {
        interval = "1 day";
        default-retention-period = "6 weeks";
      };
    };
  };
}
