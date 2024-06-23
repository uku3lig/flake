{...}: {
  cfTunnels."uku.moe" = "http://localhost:8081";

  virtualisation.oci-containers.containers.shlink = {
    image = "shlinkio/shlink:stable";
    ports = ["8081:8080"];
    environment = {
      DEFAULT_DOMAIN = "uku.moe";
      IS_HTTPS_ENABLED = "true";
      BASE_PATH = "/s";
    };
  };
}
