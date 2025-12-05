{
  config,
  ...
}:
let
  mkHttpEndpoint = name: group: url: {
    inherit name group url;
    interval = "5m";
    conditions = [
      "[STATUS] < 300"
      "[CONNECTED] == true"
    ];
  };
in
{
  services = {
    gatus = {
      enable = true;

      settings = {
        web.port = 8080;

        storage = {
          type = "sqlite";
          path = "/var/lib/gatus/gatus.sqlite";
        };

        ui = {
          title = "uku's services | status";
          description = "services status powered by gatus";
          header = "uku's services";
          logo = "https://avatars.githubusercontent.com/u/61147779?v=4";
          link = "https://git.uku3lig.net/uku/flake";
        };

        endpoints = [
          (mkHttpEndpoint "Website" "core" "https://uku3lig.net")

          (mkHttpEndpoint "API" "etna" "https://api.uku3lig.net/downloads/uku")
          (mkHttpEndpoint "Forgejo" "etna" "https://git.uku3lig.net")
          (mkHttpEndpoint "Grafana" "etna" "https://grafana.uku3lig.net")
          (mkHttpEndpoint "Immich" "etna" "https://im.uku.moe")
          (mkHttpEndpoint "Jellyfin" "etna" "https://jellyfin.uku3lig.net/web/")
          (mkHttpEndpoint "NextCloud" "etna" "https://cloud.uku3lig.net")
          (mkHttpEndpoint "Reposilite" "etna" "https://maven.uku3lig.net/")
          (mkHttpEndpoint "Shlink" "etna" "https://uku.moe/rest/v3/health")
          (mkHttpEndpoint "Slskd" "etna" "https://slsk.uku.moe")
          (mkHttpEndpoint "Synapse" "etna" "https://rei.uku.moe/_matrix/static/")
          (mkHttpEndpoint "Vaultwarden" "etna" "https://bw.uku3lig.net")
          (mkHttpEndpoint "Zipline" "etna" "https://zipline.uku3lig.net/dashboard")

          {
            name = "Maddy";
            group = "vesuvio";
            url = "starttls://mx1.uku3lig.net:587";
            interval = "5m";
            conditions = [ "[CONNECTED] == true" ];
          }
          (mkHttpEndpoint "Nitter" "vesuvio" "https://nit.uku.moe")
          (mkHttpEndpoint "Roundcube" "vesuvio" "https://mail.uku3lig.net")
        ];
      };
    };

    nginx.virtualHosts."status.uku3lig.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass =
        "http://localhost:${builtins.toString config.services.gatus.settings.web.port}";
    };
  };
}
