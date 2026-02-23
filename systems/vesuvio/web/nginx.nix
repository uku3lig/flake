# vim: foldmethod=marker
{ config, ... }:
let
  anubisBind = name: config.services.anubis.instances.${name}.settings.BIND;
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
        enableACME = true;
        locations."/".return = "404";
      };

      # === everything below this line is for services hosted on etna ===

      # cobalt: {{{
      "cobalt.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:9000";
      };
      # }}}

      # forgejo: {{{
      "git.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://unix:${anubisBind "forgejo"}";

        extraConfig = ''
          client_max_body_size 200M;
        '';
      };
      # }}}

      # immich {{{
      "im.uku.moe" = {
        forceSSL = true;
        enableACME = true;
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
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:8096";
      };
      # }}}

      # metrics {{{
      "grafana.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:2432";
      };

      "metrics.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        # This is strictly a write-only exposure so anything else can explod.
        locations."/".return = "444";
        locations."~* /api/.*/write".proxyPass = "http://etna:9089";
      };
      # }}}

      # nextcloud {{{
      "cloud.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:80";

        extraConfig = ''
          client_max_body_size 500M;
        '';
      };
      # }}}

      # paperless-ngx {{{
      "paper.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:28981";

        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
      # }}}

      # radicale {{{
      "dav.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:5232";
      };
      # }}}

      # reposilite {{{
      "maven.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:8080";

        extraConfig = ''
          client_max_body_size 500M;
        '';
      };
      # }}}

      # shlink {{{
      "uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:8081";
      };
      # }}}

      # slskd {{{
      "slsk.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:5030";
      };
      # }}}

      # synapse {{{
      "rei.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations =
          let
            server = {
              "m.server" = "rei.uku.moe:443";
            };
            client = {
              "m.homeserver"."base_url" = "https://rei.uku.moe";
            };
          in
          {
            "=/.well-known/matrix/server" = {
              return = "200 '${builtins.toJSON server}'";
            };

            "=/.well-known/matrix/client" = {
              return = "200 '${builtins.toJSON client}'";
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
      # }}}

      # vaultwarden {{{
      "bw.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://etna:8222";
      };
      # }}}

      # zipline {{{
      "zipline.uku3lig.net" = {
        serverAliases = [ "v.uku.moe" ];
        forceSSL = true;
        enableACME = true;
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

  # required due to unix socket permissions
  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];

  # anubis
  services.anubis.instances."forgejo" = {
    settings = {
      TARGET = "http://etna:3000";
      BIND = "/run/anubis/anubis-forgejo/anubis.sock";
      METRICS_BIND = "/run/anubis/anubis-forgejo/anubis-metrics.sock";
    };

    botPolicy = {
      bots = [
        { import = "(data)/meta/default-config.yaml"; }
        {
          name = "allow-git-nex";
          action = "ALLOW";
          expression = "userAgent.contains(\"GitNex\")";
        }
      ];
    };
  };
}
