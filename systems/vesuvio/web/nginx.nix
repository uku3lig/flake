# vim: foldmethod=marker
{
  config,
  _utils,
  ...
}:
let
  anubisBind = name: config.services.anubis.instances.${name}.settings.BIND;
in
{
  services.nginx = {
    enable = true;

    virtualHosts = {
      # default server
      "vps.uku3lig.net" = {
        default = true;
        addSSL = true;
        forceSSL = false;
        locations."/".return = "404";
      };

      # === everything below this line is for services hosted on etna ===

      # api {{{
      "api.uku3lig.net" = {
        locations = {
          "/".proxyPass = "http://etna:5000";
          "/tiers".return = "404";
        };
      };
      # }}}

      # cobalt: {{{
      "cobalt.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:9000";
      };
      # }}}

      # forgejo: {{{
      "git.uku3lig.net" = {
        locations."/".proxyPass = "http://unix:${anubisBind "forgejo"}";

        extraConfig = ''
          client_max_body_size 200M;
        '';
      };
      # }}}

      # immich {{{
      "im.uku.moe" = {
        locations."/" = {
          proxyPass = "http://etna:2283";
          proxyWebsockets = true;
        };

        extraConfig = ''
          client_max_body_size 5000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
      # }}}

      # jellyfin: {{{
      "jellyfin.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:8096";
      };
      # }}}

      # memos {{{
      "memos.uku3lig.net" = {
        locations = {
          "/".proxyPass = "http://etna:5230";
          "/api/v1/".proxyPass = "http://etna:5231";
          "/o/r/".proxyPass = "http://etna:5231";
        };
      };
      # }}}

      # metrics {{{
      "grafana.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:2432";
      };

      "metrics.uku3lig.net" = {
        # This is strictly a write-only exposure so anything else can explod.
        locations."/".return = "444";
        locations."~* /api/.*/write".proxyPass = "http://etna:9089";
      };
      # }}}

      # paperless-ngx {{{
      "paper.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:28981";

        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
      # }}}

      # reposilite {{{
      "maven.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:8080";

        extraConfig = ''
          client_max_body_size 500M;
        '';
      };
      # }}}

      # shlink {{{
      "uku.moe" = {
        locations."/".proxyPass = "http://etna:8081";
      };
      # }}}

      # slskd {{{
      "slsk.uku.moe" = {
        locations."/".proxyPass = "http://etna:5030";
      };
      # }}}

      # synapse {{{
      "rei.uku.moe" = {
        locations = {
          "=/.well-known/matrix/server" = _utils.mkNginxJson {
            "m.server" = "rei.uku.moe:443";
          };

          "=/.well-known/matrix/client" = _utils.mkNginxJson {
            "m.homeserver"."base_url" = "https://rei.uku.moe";
            "org.matrix.msc2965.authentication" = {
              "issuer" = "https://auth.rei.uku.moe/";
              "account" = "https://auth.rei.uku.moe/account/";
            };
            "org.matrix.msc4143.rtc_foci" = [
              {
                "type" = "livekit";
                "livekit_service_url" = "https://rei.uku.moe/livekit/jwt";
              }
            ];
          };

          "~ ^/_matrix/client/(.*)/(login|logout|refresh)" = {
            proxyPass = "http://etna:8010"; # mas
            priority = 990;
          };

          "~ ^(/_matrix|/_synapse/client)" = {
            proxyPass = "http://etna:8009";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout         600;
              client_max_body_size       1000M;
            '';
          };
        };
      };

      "auth.rei.uku.moe" = {
        locations."/".proxyPass = "http://etna:8010";
      };
      # }}}

      # vaultwarden {{{
      "bw.uku3lig.net" = {
        locations."/".proxyPass = "http://etna:8222";
      };
      # }}}

      # zipline {{{
      "zipline.uku3lig.net" = {
        serverAliases = [ "v.uku.moe" ];
        locations."/".proxyPass = "http://etna:3001";

        extraConfig = ''
          client_max_body_size 1000M;
        '';
      };
      # }}}
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # we depend on etna, which makes nginx fail if it's started before tailscale
  systemd.services.nginx.after = [ "tailscaled.service" ];
}
