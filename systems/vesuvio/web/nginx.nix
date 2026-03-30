# vim: foldmethod=marker
{ lib, config, ... }:
let
  anubisBind = name: config.services.anubis.instances.${name}.settings.BIND;

  _vhost =
    a:
    lib.mkMerge [
      a
      {
        forceSSL = true;
        useACMEHost = "vps.uku3lig.net";
      }
    ];
in
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # default server
      "vps.uku3lig.net" = {
        default = true;
        addSSL = true;
        useACMEHost = "vps.uku3lig.net";
        locations."/".return = "404";
      };

      # === everything below this line is for services hosted on etna ===

      # api {{{
      "api.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:5000";
      };
      # }}}

      # cobalt: {{{
      "cobalt.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:9000";
      };
      # }}}

      # forgejo: {{{
      "git.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://unix:${anubisBind "forgejo"}";

        extraConfig = ''
          client_max_body_size 200M;
        '';
      };
      # }}}

      # immich {{{
      "im.uku.moe" = _vhost {
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
      "jellyfin.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:8096";
      };
      # }}}

      # memos {{{
      "memos.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:5230";
      };
      # }}}

      # metrics {{{
      "grafana.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:2432";
      };

      "metrics.uku3lig.net" = _vhost {
        # This is strictly a write-only exposure so anything else can explod.
        locations."/".return = "444";
        locations."~* /api/.*/write".proxyPass = "http://etna:9089";
      };
      # }}}

      # paperless-ngx {{{
      "paper.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:28981";

        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
      # }}}

      # reposilite {{{
      "maven.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:8080";

        extraConfig = ''
          client_max_body_size 500M;
        '';
      };
      # }}}

      # shlink {{{
      "uku.moe" = _vhost {
        locations."/".proxyPass = "http://etna:8081";
      };
      # }}}

      # slskd {{{
      "slsk.uku.moe" = _vhost {
        locations."/".proxyPass = "http://etna:5030";
      };
      # }}}

      # synapse {{{
      "rei.uku.moe" = _vhost {
        locations =
          let
            server = {
              "m.server" = "rei.uku.moe:443";
            };
            client = {
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
          in
          {
            "=/.well-known/matrix/server" = {
              return = "200 '${builtins.toJSON server}'";
              extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin *;
              '';
            };

            "=/.well-known/matrix/client" = {
              return = "200 '${builtins.toJSON client}'";
              extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin *;
              '';
            };

            "~ ^/_matrix/client/(.*)/(login|logout|refresh)" = {
              proxyPass = "http://etna:8010"; # mas
              priority = 990;
            };

            "/" = {
              proxyPass = "http://etna:8009";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout         600;
                client_max_body_size       1000M;
              '';
            };
          };
      };

      "auth.rei.uku.moe" = _vhost {
        locations."/".proxyPass = "http://etna:8010";
      };
      # }}}

      # vaultwarden {{{
      "bw.uku3lig.net" = _vhost {
        locations."/".proxyPass = "http://etna:8222";
      };
      # }}}

      # zipline {{{
      "zipline.uku3lig.net" = _vhost {
        serverAliases = [ "v.uku.moe" ];
        locations."/".proxyPass = "http://etna:3001";

        extraConfig = ''
          client_max_body_size 1000M;
        '';
      };
      # }}}
    };
  };

  # we depend on etna, which makes nginx fail if it's started before tailscale
  systemd.services.nginx.after = [ "tailscaled.service" ];
}
